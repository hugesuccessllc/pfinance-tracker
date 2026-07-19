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

  def initialize(api_key_file: ".fec_api_key")
    @api_key = load_api_key(api_key_file)
    abort "fec-api-client.rb: FEC API key not found (expected #{api_key_file})" unless @api_key
  end

  # Download all schedule data for a committee via the OpenFEC API
  def download_committee_data(committee_id, output_dir, principal: false)
    committee_dir = File.join(output_dir, committee_id)

    puts "=" * 80
    puts "DOWNLOADING DATA FOR COMMITTEE #{committee_id}"
    if principal
      puts "  [PRINCIPAL COMMITTEE]"
    end
    puts "=" * 80

    # Check for cached data in repo
    cached_dir = find_cached_committee(committee_id)
    if cached_dir && cached_dir != committee_dir
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

      SCHEDULES.each do |schedule|
        download_schedule(schedule, committee_id, committee_dir)
      end

      download_efile_data(committee_id, committee_dir)
    end

    # Mark as principal committee if requested
    if principal
      principal_marker = File.join(committee_dir, "PRINCIPAL")
      File.write(principal_marker, "")
      puts "✓ Marked as principal committee"
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

  # Search repo for cached committee data
  def find_cached_committee(committee_id)
    # Search from git root for directories matching committee ID
    git_root = `git rev-parse --show-toplevel 2>/dev/null`.strip
    return nil if git_root.empty?

    # Look for committee directories in fec subdirectories
    Dir.glob(File.join(git_root, "**/fec/#{committee_id}")).each do |dir|
      next unless File.directory?(dir)
      # Verify it has FEC data (schedule or efile files)
      has_data = Dir.glob(File.join(dir, "schedule_*.csv")).any? ||
                 Dir.glob(File.join(dir, "efile-*.csv")).any?
      return dir if has_data
    end

    nil
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

  def download_schedule(schedule, committee_id, output_dir)
    puts "Downloading #{schedule}..."

    all_rows = []
    headers = nil
    page = 1
    total_pages = nil

    loop do
      url = "#{BASE_URL}/schedules/#{schedule}/" \
            "?committee_id=#{committee_id}" \
            "&per_page=#{PAGE_SIZE}" \
            "&page=#{page}" \
            "&api_key=#{@api_key}"

      response = fetch_url(url)
      results = response["results"] || []

      # Extract headers from first response
      if headers.nil? && results.any?
        headers = results.first.keys
      end

      total_pages ||= response.dig("pagination", "pages") || 1
      puts "  Page #{page}/#{total_pages}... (#{results.length} rows)"

      all_rows.concat(results)

      break if page >= total_pages

      page += 1
    end

    # Write to CSV (uncompressed for direct greppability)
    if all_rows.any? && headers
      filename = "#{schedule}-#{Time.now.iso8601}.csv"
      filepath = File.join(output_dir, filename)

      File.open(filepath, "w") do |f|
        CSV.new(f) do |csv|
          csv << headers
          all_rows.each { |row| csv << headers.map { |h| row[h] } }
        end
      end

      puts "  ✓ Saved #{all_rows.length} rows to #{filename}"
    else
      puts "  (no data found)"
    end
  end

  def download_efile_data(committee_id, output_dir)
    puts "Downloading efile data..."

    page = 1
    total_pages = nil
    efile_count = 0

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
        rescue StandardError => e
          # Skip on error
        end
      end

      break if page >= total_pages

      page += 1
    end

    puts "  ✓ Downloaded #{efile_count} efile CSV(s)"
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
    client.download_committee_data(options[:committee_id], options[:output_dir], principal: options[:principal] || false)

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
