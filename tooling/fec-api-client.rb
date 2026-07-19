#!/usr/bin/env ruby
# frozen_string_literal: true

# This tool is usually run from the repo root, but its Gemfile lives here in
# tooling/ — pin it explicitly so plain `ruby tooling/fec-api-client.rb`
# resolves gems (csv is a bundled gem as of Ruby 3.4) from any working
# directory, without needing `bundle exec` or a BUNDLE_GEMFILE= prefix.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("Gemfile", __dir__)
require "bundler/setup"

require "net/http"
require "json"
require "optparse"
require "uri"
require "fileutils"
require "csv"
require "zlib"
require "time"
require "timeout"

# FEC API client — automated committee filing downloader.
#
# Downloads Schedule A (receipts) and Schedule B (disbursements) data
# via the OpenFEC API, saving as CSV files to disk.
#
# USAGE
#   bundle exec ruby fec-api-client.rb --download --committee-id C00719294 --output-dir tx-11/august-pfluger/fec
#   bundle exec ruby fec-api-client.rb --fec-dir tx-11/august-pfluger/fec

class FecApiClient
  BASE_URL = "https://api.open.fec.gov/v1"
  SCHEDULES = ["schedule_a", "schedule_b"].freeze
  PAGE_SIZE = 100  # Max records per API request (0-100)
  REQUEST_PACING_SECONDS = 0.5  # Delay between successful requests to avoid tripping burst limits

  # schedule_a and schedule_b responses embed full nested objects for any entity
  # that's itself a committee: "committee" (the reporting committee's own
  # metadata — name, address, treasurer, cycle history — identical on every row
  # for a given file), schedule_b's "recipient_committee" (when the payee is a
  # committee, e.g. an NRCC transfer), and schedule_a's "contributor" (when the
  # donor is a committee, e.g. a PAC-to-PAC contribution). All three duplicate
  # data already available as flat fields (committee_id, recipient_committee_id,
  # contributor_name, etc.) that analyze-candidate.rb actually reads, and can
  # inflate file size 4-5x for zero informational gain. Dropped from the header
  # set before any row is written. If a future schedule type turns out to embed
  # a similarly-shaped object under still another key, add it here rather than
  # rediscovering the bloat by staring at file sizes again.
  NESTED_METADATA_FIELDS = %w[committee recipient_committee contributor].freeze

  def initialize(api_key_file: ".fec_api_key")
    @api_key = load_api_key(api_key_file)
    abort "fec-api-client.rb: FEC API key not found (expected #{api_key_file})" unless @api_key
  end

  # Download all schedule data for a committee via the OpenFEC API
  def download_committee_data(committee_id, output_dir, principal: false, with_affiliated: false, affiliated_committee_id: nil, cycle: nil)
    committee_dir = File.join(output_dir, committee_id)

    puts "=" * 80
    puts "DOWNLOADING DATA FOR COMMITTEE #{committee_id}"
    if principal
      puts "  [PRINCIPAL COMMITTEE]"
    end
    if cycle
      puts "  [CYCLE #{cycle} ONLY]"
    end
    puts "=" * 80

    if Dir.exist?(committee_dir) && Dir.glob(File.join(committee_dir, "schedule_*.csv")).any?
      resolve_local_download(committee_id, committee_dir, cycle)
    else
      # Check for cached data elsewhere in repo — only use it if its manifest actually
      # covers what we need; otherwise fall through to a fresh local download.
      cached_dir = find_cached_committee(committee_id, cycle: cycle, exclude_dir: committee_dir)
      cached_manifest = cached_dir ? read_cycles_manifest(cached_dir) : nil

      if cached_dir && manifest_covers?(cached_manifest, cycle)
        puts "Found cached data: #{cached_dir}"
        puts "Copying to: #{committee_dir}"
        FileUtils.mkdir_p(output_dir)
        FileUtils.cp_r(cached_dir, committee_dir)
        puts "✓ Cached data copied (skipped API download)"
        puts
      else
        FileUtils.mkdir_p(committee_dir)
        puts "Output: #{committee_dir}"
        puts

        perform_download(committee_id, committee_dir, cycle)
        write_cycles_manifest(committee_dir, cycle ? Set[cycle] : :all)
      end
    end

    # Mark as principal committee if requested
    if principal
      principal_marker = File.join(committee_dir, "PRINCIPAL")
      File.write(principal_marker, "")
      puts "✓ Marked as principal committee"
    end

    # Write committee-level progress marker
    progress_marker = File.join(committee_dir, ".download-progress")
    File.write(progress_marker, "timestamp: #{Time.now.iso8601}\ncommittee_id: #{committee_id}\nstatus: complete\n")

    # Auto-discover (by name) or directly fetch the principal's affiliated committee
    # (JFC, leadership PAC) if requested. Deliberately NOT a recursive Schedule-B
    # transfer crawl — that approach (kept in git history, since removed) pulled in
    # every committee a transfer ever touched, including large unrelated ones like
    # the NRCC, which isn't "this candidate's" committee just because they wrote it
    # a check. Only totals are fetched for the affiliated committee, not itemized
    # Schedule A/B — see download_committee_totals.
    if with_affiliated || affiliated_committee_id
      puts "\n" + "=" * 80
      puts "AFFILIATED COMMITTEE"
      puts "=" * 80

      target_id = affiliated_committee_id
      unless target_id
        match = discover_affiliated_committee(committee_id)
        target_id = match && match["committee_id"]
      end

      if target_id
        download_committee_totals(target_id, output_dir, cycle: cycle)
      else
        puts "No affiliated committee to download."
      end
    end

    puts "\n✓ Download complete"
  end

  # Fetch a committee's own detail record, which (when the filer supplied it on
  # their Form 1) includes affiliated_committee_name — free-text naming a JFC or
  # leadership PAC the committee is tied to. There is no structured committee-ID
  # field for this relationship; resolving the name to an ID requires a separate
  # committee name search (see discover_affiliated_committee).
  def fetch_committee_detail(committee_id)
    url = "#{BASE_URL}/committee/#{committee_id}/?api_key=#{@api_key}"
    (fetch_url(url)["results"] || []).first
  end

  # Resolve a committee's affiliated_committee_name (see fetch_committee_detail) to
  # an actual committee ID via FEC's committee name search. Prefers an exact
  # case-insensitive name match; if the search returns several plausible matches
  # with none exact, prints them and asks the human to pick via
  # --affiliated-committee-id rather than guessing.
  #
  # affiliated_committee_name is filer-supplied free text and doesn't always match
  # the affiliated committee's actual registered name — e.g. August Pfluger's
  # principal committee lists "PFLUGER VICTORY FUND", but the JFC is registered as
  # "PFLUGER VICTORY COMMITTEE". A full-phrase search for the exact string can
  # return zero results even though the committee exists, because the search
  # doesn't fuzzy-match a wrong trailing word. If the full name draws a blank, retry
  # once with the last word dropped (candidate/JFC names are conventionally
  # "<surname> <word> <word>", so the earlier words are the more reliable anchor).
  def discover_affiliated_committee(committee_id)
    detail = fetch_committee_detail(committee_id)
    name = detail && detail["affiliated_committee_name"].to_s.strip

    if name.nil? || name.empty?
      puts "#{committee_id} has no affiliated_committee_name on file."
      return nil
    end

    puts "Affiliated committee name on file: \"#{name}\" — searching for its committee ID..."
    matches = search_committees_by_name(name, exclude: committee_id)

    words = name.split(/\s+/)
    if matches.empty? && words.length > 1
      trimmed = words[0..-2].join(" ")
      puts "No match for the full name — retrying with \"#{trimmed}\"..."
      matches = search_committees_by_name(trimmed, exclude: committee_id)
    end

    exact = matches.select { |c| c["name"].to_s.strip.casecmp?(name) }
    candidates = exact.any? ? exact : matches

    case candidates.length
    when 0
      puts "No committee found matching \"#{name}\"."
      nil
    when 1
      puts "Matched: #{candidates.first["committee_id"]} (#{candidates.first["name"]})"
      candidates.first
    else
      puts "\"#{name}\" matched #{candidates.length} committees — re-run with --affiliated-committee-id to pick one:"
      candidates.each { |c| puts "  - #{c["committee_id"]} | #{c["name"]} | #{c["state"]} | #{c["designation_full"]}" }
      nil
    end
  end

  def search_committees_by_name(name, exclude: nil)
    url = "#{BASE_URL}/committees/?q=#{URI.encode_www_form_component(name)}&api_key=#{@api_key}&per_page=20"
    (fetch_url(url)["results"] || []).reject { |c| c["committee_id"] == exclude }
  end

  # Fetch committee-level financial totals (receipts/disbursements/cash-on-hand per
  # cycle) WITHOUT itemized Schedule A/B rows. Used for a candidate's affiliated
  # committee (JFC, leadership PAC) — enough to see the scale of money moving
  # through it without pulling its full transaction history, which for some
  # affiliated committees can dwarf the principal committee's own itemized data.
  def download_committee_totals(committee_id, output_dir, cycle: nil)
    committee_dir = File.join(output_dir, committee_id)
    FileUtils.mkdir_p(committee_dir)

    detail = fetch_committee_detail(committee_id) || {}

    url = "#{BASE_URL}/committee/#{committee_id}/totals/?api_key=#{@api_key}&per_page=100"
    url += "&cycle=#{cycle}" if cycle
    totals = fetch_url(url)["results"] || []

    payload = {
      "committee_id" => committee_id,
      "name" => detail["name"],
      "designation_full" => detail["designation_full"],
      "committee_type_full" => detail["committee_type_full"],
      "totals_by_cycle" => totals
    }

    File.write(File.join(committee_dir, "totals.json"), JSON.pretty_generate(payload))
    File.write(File.join(committee_dir, "AFFILIATED"), "")
    puts "✓ Saved totals for #{totals.length} cycle(s) to #{committee_id}/totals.json " \
         "(#{detail["name"] || "name unknown"}) — no itemized data fetched"
  end

  # Search repo for cached committee data. Prefers a cache whose manifest already
  # covers the requested cycle (or full history); falls back to any cache with data
  # if none is sufficient, letting the caller decide whether to use it.
  def find_cached_committee(committee_id, cycle: nil, exclude_dir: nil)
    git_root = `git rev-parse --show-toplevel 2>/dev/null`.strip
    return nil if git_root.empty?

    exclude_real = (exclude_dir && Dir.exist?(exclude_dir)) ? File.realpath(exclude_dir) : nil

    candidates = Dir.glob(File.join(git_root, "**/fec/#{committee_id}")).select do |dir|
      File.directory?(dir) &&
        (exclude_real.nil? || File.realpath(dir) != exclude_real) &&
        (Dir.glob(File.join(dir, "schedule_*.csv")).any? || Dir.glob(File.join(dir, "efile-*.csv")).any?)
    end

    candidates.find { |dir| manifest_covers?(read_cycles_manifest(dir), cycle) } || candidates.first
  end

  # Cycle manifest tracks which two_year_transaction_period values a committee
  # directory's schedule files already cover, so we never re-download a cycle we
  # have, and never let an overlapping cycle land in two files (which would double-
  # count transactions, since analyze-candidate.rb concatenates all schedule_*.csv
  # files in a directory without deduping across files).
  def read_cycles_manifest(committee_dir)
    path = File.join(committee_dir, ".cycles-downloaded")
    return nil unless File.exist?(path)

    content = File.read(path).strip
    return :all if content == "ALL"
    return Set.new if content.empty?

    Set.new(content.split(",").map(&:to_i))
  end

  def write_cycles_manifest(committee_dir, cycles_or_all)
    path = File.join(committee_dir, ".cycles-downloaded")
    File.write(path, cycles_or_all == :all ? "ALL" : cycles_or_all.to_a.sort.join(","))
  end

  # true if the manifest already has everything a request for `cycle` needs
  # (nil cycle means "full history requested", which only :all satisfies)
  def manifest_covers?(manifest, cycle)
    return true if manifest == :all
    return false if manifest.nil? || cycle.nil?

    manifest.include?(cycle)
  end

  # Decide whether an existing local committee directory already satisfies this
  # request, needs a disjoint top-up (new cycle, existing cycles untouched), or
  # needs a full re-download that supersedes (and removes) partial cycle data.
  def resolve_local_download(committee_id, committee_dir, cycle)
    manifest = read_cycles_manifest(committee_dir)

    if manifest_covers?(manifest, cycle)
      puts "✓ Already have #{cycle ? "cycle #{cycle}" : "full history"} for #{committee_id} locally — skipping download"
      puts
      return
    end

    if cycle && manifest.is_a?(Set)
      puts "Have cycles #{manifest.to_a.sort.join(", ")} locally; fetching cycle #{cycle} to add..."
      puts
      download_schedule("schedule_a", committee_id, committee_dir, cycle: cycle)
      download_schedule("schedule_b", committee_id, committee_dir, cycle: cycle)
      write_cycles_manifest(committee_dir, manifest + Set[cycle])
      return
    end

    # Full history requested but only partial cycles (or no manifest at all, e.g.
    # data predating this feature) are on disk. Supersede rather than append, since
    # a full pull re-fetches every cycle including the ones already present.
    if manifest.is_a?(Set)
      puts "Full history requested but only cycles #{manifest.to_a.sort.join(", ")} are cached locally."
    else
      puts "Existing data has no cycle manifest (predates cycle tracking) — treating as incomplete."
    end
    superseded = Dir.glob(File.join(committee_dir, "schedule_*.csv*"))
    if superseded.any?
      puts "Removing #{superseded.length} superseded file(s) before full download: #{superseded.map { |f| File.basename(f) }.join(", ")}"
      superseded.each { |f| File.delete(f) }
    end
    puts

    perform_download(committee_id, committee_dir, cycle)
    write_cycles_manifest(committee_dir, cycle ? Set[cycle] : :all)
  end

  # Fetch schedule_a/schedule_b (optionally cycle-scoped) plus efile data. Efile
  # filings aren't cycle-filterable and analyze-candidate.rb doesn't read them for
  # totals anyway (see its header comments), so skip re-fetching if any are present.
  def perform_download(committee_id, committee_dir, cycle)
    SCHEDULES.each do |schedule|
      download_schedule(schedule, committee_id, committee_dir, cycle: cycle)
    end

    if Dir.glob(File.join(committee_dir, "efile-*.csv")).empty?
      download_efile_data(committee_id, committee_dir)
    else
      puts "Efile data already present locally — skipping efile re-fetch"
    end
  end

  # List downloaded files in an FEC directory
  def list_downloaded_files(fec_dir)
    puts "=" * 80
    puts "DOWNLOADED FILES IN #{fec_dir}"
    puts "=" * 80
    puts

    committees = Dir.glob(File.join(fec_dir, "C*")).select { |d| File.directory?(d) }

    if committees.empty?
      puts "No committee directories found."
      return
    end

    committees.each do |committee_dir|
      committee_id = File.basename(committee_dir)
      files = Dir.glob(File.join(committee_dir, "*")).reject { |f| File.directory?(f) }.sort

      puts "#{committee_id}: #{files.length} file(s)"
      files.each { |f| puts "  - #{File.basename(f)}" }
    end
    puts
  end

  private

  def download_schedule(schedule, committee_id, output_dir, cycle: nil)
    puts "Downloading #{schedule}#{cycle ? " (cycle #{cycle})" : ""}..."

    filename = "#{schedule}-#{Time.now.iso8601}.csv"
    filepath = File.join(output_dir, filename)
    meta_filepath = "#{filepath}.meta"

    headers = nil
    page_count = 0
    total_pages = nil
    total_rows = 0
    cursor = {}

    # /schedules/schedule_a and schedule_b silently ignore a plain &page=N param
    # once the result set is large enough — every "page" from 1 to N returns the
    # IDENTICAL first 100 rows (confirmed empirically: a committee with 16,055
    # schedule_a rows produced exactly 100 unique transaction_ids, each repeated
    # 161 times — 100 x 161 = 16,100, matching the page count we were requesting).
    # The API expects seek/cursor pagination instead: each response's
    # pagination.last_indexes (e.g. {"last_index"=>"...", "last_contribution_receipt_date"=>"..."}
    # for schedule_a; last_disbursement_date for schedule_b) must be echoed back
    # as query params to get the NEXT page. Termination is by result-count
    # (fewer than PAGE_SIZE rows back means this was the last page), not by
    # comparing against pagination.pages — that field is still fetched for
    # display purposes only.
    loop do
      url = "#{BASE_URL}/schedules/#{schedule}/" \
            "?committee_id=#{committee_id}" \
            "&per_page=#{PAGE_SIZE}" \
            "&api_key=#{@api_key}"
      url += "&two_year_transaction_period=#{cycle}" if cycle
      cursor.each { |k, v| url += "&#{k}=#{URI.encode_www_form_component(v.to_s)}" }

      response = fetch_url(url)
      results = response["results"] || []
      page_count += 1

      # Extract headers from first response
      if headers.nil? && results.any?
        headers = results.first.keys - NESTED_METADATA_FIELDS
        # Write header row on first page
        # NOTE: CSV.new(f) { |csv| ... } silently discards writes — the block form
        # doesn't behave like CSV.open. Must call csv << directly on the returned object.
        File.open(filepath, "w") do |f|
          csv = CSV.new(f)
          csv << headers
        end
      end

      total_pages ||= response.dig("pagination", "pages") || 1

      # Append data rows incrementally
      if results.any? && headers
        File.open(filepath, "a") do |f|
          csv = CSV.new(f)
          results.each { |row| csv << headers.map { |h| row[h] } }
          csv.flush
          f.flush
        end
        total_rows += results.length
      end

      # Write progress metadata
      write_schedule_meta(meta_filepath, page_count, total_pages, total_rows, "in_progress")
      puts "  Page #{page_count}/#{total_pages}... (#{results.length} rows, #{total_rows} total)"

      break if results.length < PAGE_SIZE

      next_cursor = response.dig("pagination", "last_indexes")
      break if next_cursor.nil? || next_cursor.empty?

      cursor = next_cursor
      sleep(REQUEST_PACING_SECONDS)
    end

    # Mark as complete
    if total_rows > 0 && headers
      write_schedule_meta(meta_filepath, total_pages, total_pages, total_rows, "complete")
      puts "  ✓ Saved #{total_rows} rows to #{filename}"
    else
      puts "  (no data found)"
    end
  end

  def write_schedule_meta(filepath, pages_fetched, total_pages, rows_written, status)
    meta = {
      timestamp: Time.now.iso8601,
      pages_fetched: pages_fetched,
      total_pages: total_pages,
      rows_written: rows_written,
      status: status
    }
    File.write(filepath, meta.map { |k, v| "#{k}: #{v}" }.join("\n"))
  end

  def download_efile_data(committee_id, output_dir)
    puts "Downloading efile data..."

    page = 1
    total_pages = nil
    efile_count = 0
    efile_meta_file = File.join(output_dir, ".efile-progress")

    loop do
      url = "#{BASE_URL}/efile/filings/" \
            "?committee_id=#{committee_id}" \
            "&per_page=#{PAGE_SIZE}" \
            "&page=#{page}" \
            "&api_key=#{@api_key}"

      response = fetch_url(url)
      filings = response["results"] || []

      total_pages ||= response.dig("pagination", "pages") || 1
      puts "  Page #{page}/#{total_pages}... (#{filings.length} filings)"

      filings.each do |filing|
        csv_url = filing["csv_url"]
        filed_date = filing["filed_date"]

        next unless csv_url

        begin
          # Download the CSV file from the external URL
          csv_data = download_external_csv(csv_url)
          next unless csv_data

          # Save with timestamp
          filename = "efile-#{filed_date}T#{Time.now.strftime('%H_%M_%S')}.csv"
          filepath = File.join(output_dir, filename)
          File.write(filepath, csv_data)
          efile_count += 1

          # Write efile progress metadata
          write_efile_meta(efile_meta_file, page, total_pages, efile_count, "in_progress")
        rescue StandardError
          # Skip on error
        end
      end

      break if page >= total_pages

      page += 1
      sleep(REQUEST_PACING_SECONDS)
    end

    # Mark efile download as complete
    write_efile_meta(efile_meta_file, total_pages, total_pages, efile_count, "complete") if efile_count > 0
    puts "  ✓ Downloaded #{efile_count} efile CSV(s)"
  end

  def write_efile_meta(filepath, pages_fetched, total_pages, files_downloaded, status)
    meta = {
      timestamp: Time.now.iso8601,
      pages_fetched: pages_fetched,
      total_pages: total_pages,
      files_downloaded: files_downloaded,
      status: status
    }
    File.write(filepath, meta.map { |k, v| "#{k}: #{v}" }.join("\n"))
  end

  def download_external_csv(url, retry_count: 0, max_retries: 5)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 30
    http.read_timeout = 60

    request = Net::HTTP::Get.new(uri.request_uri)
    response = Timeout.timeout(90) { http.request(request) }

    if response.code == "429" || %w[502 503 504].include?(response.code)
      if retry_count >= max_retries
        return nil
      end
      wait_seconds = 2 ** retry_count
      sleep(wait_seconds)
      return download_external_csv(url, retry_count: retry_count + 1, max_retries: max_retries)
    end

    return nil unless response.code == "200"

    response.body
  rescue Timeout::Error
    return nil if retry_count >= max_retries
    sleep(2 ** retry_count)
    download_external_csv(url, retry_count: retry_count + 1, max_retries: max_retries)
  rescue StandardError
    nil
  end

  def load_api_key(filename)
    return ENV["FEC_API_KEY"] if ENV["FEC_API_KEY"]

    key_file = File.expand_path(filename, File.dirname(__FILE__) + "/..")
    return File.read(key_file).strip if File.exist?(key_file)

    nil
  end

  def fetch_url(url, retry_count: 0, max_retries: 5)
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 30
    http.read_timeout = 60

    request = Net::HTTP::Get.new(uri.request_uri)
    request["Accept-Encoding"] = "gzip"
    # Net::HTTP's open_timeout/read_timeout don't reliably bound every hang (observed:
    # a request stuck for 18+ minutes with neither timeout firing, while a plain curl
    # to the same URL returned in under a second) — wrap in a hard wall-clock timeout
    # as a backstop so one wedged socket can't block an entire download run.
    response = Timeout.timeout(90) { http.request(request) }

    if response.code == "429"
      if retry_count >= max_retries
        abort "fec-api-client.rb: Rate limited (HTTP 429) after #{max_retries} retries. Try again in a few minutes."
      end
      wait_seconds = 2 ** retry_count  # Exponential backoff: 1, 2, 4, 8, 16...
      puts "⚠ Rate limited (HTTP 429). Waiting #{wait_seconds}s before retry #{retry_count + 1}/#{max_retries}..."
      sleep(wait_seconds)
      return fetch_url(url, retry_count: retry_count + 1, max_retries: max_retries)
    end

    # 502/503/504 are transient gateway/server errors from the FEC API under load,
    # not rate limiting — worth the same exponential backoff rather than aborting
    # and losing all download progress on a single hiccup.
    if %w[502 503 504].include?(response.code)
      if retry_count >= max_retries
        abort "fec-api-client.rb: HTTP #{response.code} after #{max_retries} retries."
      end
      wait_seconds = 2 ** retry_count
      puts "⚠ Transient server error (HTTP #{response.code}). Waiting #{wait_seconds}s before retry #{retry_count + 1}/#{max_retries}..."
      sleep(wait_seconds)
      return fetch_url(url, retry_count: retry_count + 1, max_retries: max_retries)
    end

    abort "fec-api-client.rb: HTTP #{response.code}" unless response.code == "200"

    body = response.body
    body = Zlib::GzipReader.new(StringIO.new(body)).read if response["content-encoding"] == "gzip"
    JSON.parse(body)
  rescue Timeout::Error
    if retry_count >= max_retries
      abort "fec-api-client.rb: Request hung past #{90}s timeout after #{max_retries} retries."
    end
    wait_seconds = 2 ** retry_count
    puts "⚠ Request hung past timeout. Waiting #{wait_seconds}s before retry #{retry_count + 1}/#{max_retries}..."
    sleep(wait_seconds)
    fetch_url(url, retry_count: retry_count + 1, max_retries: max_retries)
  rescue StandardError => e
    abort "fec-api-client.rb: Error fetching URL: #{e.message}"
  end
end

# CLI
if $PROGRAM_NAME == __FILE__
  options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: fec-api-client.rb [--download | --fec-dir DIR] [options]"
    opts.on("--download", "Download committee data via OpenFEC API") { options[:download] = true }
    opts.on("--committee-id ID", "FEC committee ID (e.g., C00719294)") { |v| options[:committee_id] = v }
    opts.on("--output-dir DIR", "Base output directory (committee ID subdir will be created)") { |v| options[:output_dir] = v }
    opts.on("-p", "--principal", "Mark this committee as the principal (main) committee") { options[:principal] = true }
    opts.on("--with-affiliated", "Look up the principal's affiliated committee (JFC/leadership PAC, by name) and fetch its financial totals only — not itemized data") { options[:with_affiliated] = true }
    opts.on("--affiliated-committee-id ID", "Skip name search; fetch totals for this specific committee ID as the affiliated committee") { |v| options[:affiliated_committee_id] = v }
    opts.on("--cycle YYYY", Integer, "Scope download to a single 2-year cycle (fewer API calls; applies to the affiliated committee's totals too)") { |v| options[:cycle] = v }
    opts.on("--fec-dir DIR", "FEC directory to inspect — lists downloaded files (e.g., tx-11/august-pfluger/fec)") { |v| options[:fec_dir] = v }
    opts.on("-h", "--help", "Show this help") do
      puts opts
      exit
    end
  end.parse!

  client = FecApiClient.new

  if options[:download]
    abort "fec-api-client.rb: --download requires --committee-id and --output-dir" unless options[:committee_id] && options[:output_dir]
    client.download_committee_data(options[:committee_id], options[:output_dir],
                                    principal: options[:principal] || false,
                                    with_affiliated: options[:with_affiliated] || false,
                                    affiliated_committee_id: options[:affiliated_committee_id],
                                    cycle: options[:cycle])

  elsif options[:fec_dir]
    client.list_downloaded_files(options[:fec_dir])

  else
    abort "fec-api-client.rb: provide --download or --fec-dir (see --help)"
  end
end
