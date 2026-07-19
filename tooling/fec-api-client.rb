#!/usr/bin/env ruby
# frozen_string_literal: true

require "net/http"
require "json"
require "optparse"
require "uri"
require "fileutils"
require "csv"
require "zlib"

# FEC API client — automated committee filing downloader.
#
# Downloads Schedule A (receipts) and Schedule B (disbursements) data
# via the OpenFEC API, saving as CSV files to disk.
#
# USAGE
#   bundle exec ruby fec-api-client.rb --committee-id C00719294 --output-dir tx-11/august-pfluger/fec
#   bundle exec ruby fec-api-client.rb --fec-dir tx-11/august-pfluger/fec --list-linked

class FecApiClient
  BASE_URL = "https://api.open.fec.gov/v1"
  SCHEDULES = ["schedule_a", "schedule_b"].freeze
  PAGE_SIZE = 100  # Max records per API request (0-100)
  REQUEST_PACING_SECONDS = 0.5  # Delay between successful requests to avoid tripping burst limits

  def initialize(api_key_file: ".fec_api_key")
    @api_key = load_api_key(api_key_file)
    abort "fec-api-client.rb: FEC API key not found (expected #{api_key_file})" unless @api_key
  end

  # Download all schedule data for a committee via the OpenFEC API
  def download_committee_data(committee_id, output_dir, principal: false, with_linked: false, cycle: nil)
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
      cached_dir = find_cached_committee(committee_id, cycle: cycle)
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

    # Auto-discover and download linked committees if requested
    if with_linked
      puts "\n" + "=" * 80
      puts "DISCOVERING LINKED COMMITTEES"
      puts "=" * 80
      linked = find_linked_committees(output_dir)
      linked_to_download = linked.reject { |c| c == committee_id }

      if linked_to_download.any?
        puts "Found #{linked_to_download.length} linked committee(s):"
        linked_to_download.each do |c|
          puts "  - #{c}"
          download_committee_data(c, output_dir, principal: false, with_linked: false, cycle: cycle)
        end
      else
        puts "No linked committees found."
      end
    end

    puts "\n✓ Download complete"
  end

  # Find linked committees in downloaded FEC data
  def find_linked_committees(fec_dir)
    linked = Set.new

    # Search all schedule_b files for transfers to other committees
    Dir.glob(File.join(fec_dir, "*", "schedule_b-*.csv")).each do |file|
      begin
        csv_data = read_csv_file(file)
        next unless csv_data

        CSV.parse(csv_data, headers: true) do |row|
          # Look for recipient committee IDs (linked committees)
          if (committee_id = row["recipient_committee_id"])&.match?(/^C\d{6,}/)
            linked << committee_id.strip
          end

          # Also look for disbursements marked as transfers
          if row["disbursement_type_description"]&.include?("Transfer")
            recipient = row["recipient_name"]&.strip
            # Try to extract committee ID from recipient name
            if recipient&.match?(/^C\d{6,}/)
              linked << recipient.strip
            end
          end
        end
      rescue StandardError => e
        # Skip on error
      end
    end

    # Also search for references in efile raw data
    Dir.glob(File.join(fec_dir, "*", "efile-*.csv")).each do |file|
      begin
        csv_data = read_csv_file(file)
        next unless csv_data

        CSV.parse(csv_data, headers: true) do |row|
          # Look for committee references in various fields
          %w[entity_id recipient_committee_id].each do |field|
            if row[field]&.match?(/^C\d{6,}/)
              linked << row[field].strip
            end
          end
        end
      rescue StandardError => e
        # Efile format may vary, skip errors gracefully
      end
    end

    linked.reject { |id| id.empty? }.sort
  end

  # Read CSV file
  def read_csv_file(filepath)
    File.read(filepath)
  rescue StandardError => e
    nil
  end

  # Search repo for cached committee data. Prefers a cache whose manifest already
  # covers the requested cycle (or full history); falls back to any cache with data
  # if none is sufficient, letting the caller decide whether to use it.
  def find_cached_committee(committee_id, cycle: nil)
    git_root = `git rev-parse --show-toplevel 2>/dev/null`.strip
    return nil if git_root.empty?

    candidates = Dir.glob(File.join(git_root, "**/fec/#{committee_id}")).select do |dir|
      File.directory?(dir) &&
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
    page = 1
    total_pages = nil
    total_rows = 0

    loop do
      url = "#{BASE_URL}/schedules/#{schedule}/" \
            "?committee_id=#{committee_id}" \
            "&per_page=#{PAGE_SIZE}" \
            "&page=#{page}" \
            "&api_key=#{@api_key}"
      url += "&two_year_transaction_period=#{cycle}" if cycle

      response = fetch_url(url)
      results = response["results"] || []

      # Extract headers from first response
      if headers.nil? && results.any?
        headers = results.first.keys
        # Write header row on first page
        File.open(filepath, "w") do |f|
          CSV.new(f) do |csv|
            csv << headers
          end
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
      write_schedule_meta(meta_filepath, page, total_pages, total_rows, "in_progress")
      puts "  Page #{page}/#{total_pages}... (#{results.length} rows, #{total_rows} total)"

      break if page >= total_pages

      page += 1
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
        rescue StandardError => e
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
    response = http.request(request)

    if response.code == "429"
      if retry_count >= max_retries
        return nil
      end
      wait_seconds = 2 ** retry_count
      sleep(wait_seconds)
      return download_external_csv(url, retry_count: retry_count + 1, max_retries: max_retries)
    end

    return nil unless response.code == "200"

    response.body
  rescue StandardError => e
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
    response = http.request(request)

    if response.code == "429"
      if retry_count >= max_retries
        abort "fec-api-client.rb: Rate limited (HTTP 429) after #{max_retries} retries. Try again in a few minutes."
      end
      wait_seconds = 2 ** retry_count  # Exponential backoff: 1, 2, 4, 8, 16...
      puts "⚠ Rate limited (HTTP 429). Waiting #{wait_seconds}s before retry #{retry_count + 1}/#{max_retries}..."
      sleep(wait_seconds)
      return fetch_url(url, retry_count: retry_count + 1, max_retries: max_retries)
    end

    abort "fec-api-client.rb: HTTP #{response.code}" unless response.code == "200"

    body = response.body
    body = Zlib::GzipReader.new(StringIO.new(body)).read if response["content-encoding"] == "gzip"
    JSON.parse(body)
  rescue StandardError => e
    abort "fec-api-client.rb: Error fetching URL: #{e.message}"
  end
end

# CLI
if $PROGRAM_NAME == __FILE__
  options = {}

  OptionParser.new do |opts|
    opts.banner = "Usage: fec-api-client.rb [--download | --list-files | --list-linked] [options]"
    opts.on("--download", "Download committee data via OpenFEC API") { options[:download] = true }
    opts.on("--committee-id ID", "FEC committee ID (e.g., C00719294)") { |v| options[:committee_id] = v }
    opts.on("--output-dir DIR", "Base output directory (committee ID subdir will be created)") { |v| options[:output_dir] = v }
    opts.on("-p", "--principal", "Mark this committee as the principal (main) committee") { options[:principal] = true }
    opts.on("--with-linked", "Auto-discover and download all linked committees found in Schedule B transfers") { options[:with_linked] = true }
    opts.on("--cycle YYYY", Integer, "Scope download to a single 2-year cycle (fewer API calls; applies to linked committees too)") { |v| options[:cycle] = v }
    opts.on("--fec-dir DIR", "FEC directory to analyze (e.g., tx-11/august-pfluger/fec)") { |v| options[:fec_dir] = v }
    opts.on("--list-files", "List all downloaded CSV files in --fec-dir") { options[:list_files] = true }
    opts.on("--list-linked", "Find linked committees in downloaded filings (requires --fec-dir)") { options[:list_linked] = true }
    opts.on("-h", "--help", "Show this help") do
      puts opts
      exit
    end
  end.parse!

  client = FecApiClient.new

  if options[:download]
    abort "fec-api-client.rb: --download requires --committee-id and --output-dir" unless options[:committee_id] && options[:output_dir]
    client.download_committee_data(options[:committee_id], options[:output_dir], principal: options[:principal] || false, with_linked: options[:with_linked] || false, cycle: options[:cycle])

  elsif options[:fec_dir]
    if options[:list_linked]
      puts "Searching for linked committees..."
      linked = client.find_linked_committees(options[:fec_dir])
      if linked.empty?
        puts "No linked committees found."
      else
        puts "\nLinked committees found:"
        linked.each { |c| puts "  - #{c}" }
        puts "\nDownload these with:"
        linked.each { |c| puts "  ruby fec-api-client.rb --download --committee-id #{c} --output-dir #{options[:fec_dir]}" }
      end

    elsif options[:list_files]
      client.list_downloaded_files(options[:fec_dir])

    else
      client.list_downloaded_files(options[:fec_dir])
    end

  else
    abort "fec-api-client.rb: provide --download, --list-files, or --list-linked (see --help)"
  end
end
