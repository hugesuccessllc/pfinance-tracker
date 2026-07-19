#!/usr/bin/env ruby
# frozen_string_literal: true

# analyze-candidate.rb — reusable financial-disclosure data miner for pfinance-tracker.
#
# Point it at a candidate's collected FEC exports (and, optionally, their House Ethics
# PDF disclosures) and it prints a data-mining report — donor lists, spending by category,
# top payees, notable single transactions, and personal stock-transaction disclosures — that
# a human or an LLM can turn into an executive summary like tx-11/august-pfluger/README.md.
#
# This script intentionally does NOT write prose. It surfaces numbers and candidate
# transactions; interpretation (which findings are newsworthy, how to phrase them) is left
# to whoever reads the report, because that judgment doesn't belong in reusable tooling.
#
# USAGE
#   bundle exec ruby analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec \
#     --house-ethics-dir tx-11/august-pfluger/house-ethics
#
#   bundle exec ruby analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --format json --out /tmp/pfluger.json
#
# DATA-MINING STRATEGY (read this before changing the filters below)
#
# FEC bulk exports ("processed data" from fec.gov/data, saved as schedule_a-*.csv for
# receipts and schedule_b-*.csv for disbursements) have two gotchas that will silently
# double- or over-count money if you naively SUM(amount):
#
#   1. memo_code == "X" marks a line as informational-only — its amount is already
#      reflected in a different, non-memo line elsewhere in the filing (this is how FEC
#      represents earmarked/conduit contributions, credit-card sub-itemization, etc.).
#      Every aggregate in this script excludes memo rows for that reason.
#
#   2. Schedule A's `line_number_label` column tells you what KIND of receipt a row is,
#      and most of what shows up there is NOT a donation from an outside supporter:
#      - "Transfers from authorized committees" — money moving between a candidate's own
#        committees, or between participants in a joint fundraising committee (JFC). A JFC
#        transferring a candidate's cut back to their campaign will otherwise show up as
#        the single largest "donor" in the dataset, which is misleading.
#      - "Total Amount of Other Receipts" — bank interest, refunds owed to the committee,
#        rebates. Not a donor relationship.
#      - "Offsets to Operating Expenditures" — refunds of the committee's own prior
#        spending (e.g. a hotel overpayment refund), booked as a receipt.
#      Only "Contributions From Individuals/Persons Other Than Political Committees" and
#      "Contributions From Other Political Committees" represent an outside party actually
#      giving the committee money. DONOR_LABELS below encodes that allowlist. If a future
#      FEC export uses different label text, this is the constant to update.
#
# A committee that raises through a joint fundraising committee (JFC) will show large
# "Transfers" entries in Schedule B representing the JFC redistributing pooled money to
# each participating committee (the candidate's own campaign, a party committee, allied
# PACs). That's a legitimate and common structure — don't mistake it for "spending" in the
# ads/staff/travel sense; category_code_full already buckets it separately as "Transfers".
#
# House Ethics Committee PDFs (Periodic Transaction Reports and annual Financial
# Disclosures) don't follow a stable machine-readable schema — they're AcroForm layouts
# that vary by filing type and year. Rather than build a brittle structured parser, this
# script extracts each PDF's text (via the pure-Ruby `pdf-reader` gem, so no system
# dependency on poppler/pdftotext) and greps for lines that look like asset/transaction
# rows (a dollar amount or a dollar range). That's a starting point for a human or LLM to
# read, not a fully-parsed dataset — verify anything you cite against the source PDF.

require "csv"
require "bigdecimal"
require "json"
require "optparse"
require "stringio"
require "pdf-reader"

# ---------------------------------------------------------------------------
# FEC receipts (Schedule A) + disbursements (Schedule B)
# ---------------------------------------------------------------------------

class FecAnalyzer
  DONOR_LABELS = [
    "Contributions From Individuals/Persons Other Than Political Committees",
    "Contributions From Other Political Committees"
  ].freeze

  Committee = Struct.new(:id, :name, :dir)

  def initialize(fec_dir, top: 15)
    @fec_dir = fec_dir
    @top = top
  end

  def committees
    @committees ||= Dir.children(@fec_dir)
                        .select { |d| d =~ /\AC\d{6,}\z/ && File.directory?(File.join(@fec_dir, d)) }
                        .sort
                        .map { |id| Committee.new(id, committee_name_for(id), File.join(@fec_dir, id)) }
  end

  def run
    donors = analyze_donors
    disbursements = analyze_disbursements
    {
      committees: committees.map { |c| { id: c.id, name: c.name } },
      donors: donors,
      disbursements: disbursements
    }
  end

  def to_text(data)
    io = StringIO.new
    print_committee_totals(io, "RECEIPTS (itemized, non-memo, donor rows only)", data[:donors][:committee_totals])
    io.puts
    io.puts "Individual vs. Committee/PAC receipts:"
    data[:donors][:individual_vs_committee].each { |k, v| io.puts "  #{k}: #{money(v)}" }
    io.puts

    print_table(io, "TOP DONORS (deduped by name+employer, across all committees)", data[:donors][:top]) do |row, i|
      committees_str = row[:by_committee].map { |cid, amt| "#{cid}: #{money(amt)}" }.join(", ")
      format("%2d. %-35s %12s  | employer: %-30s occ: %-20s %s, %s | %s",
             i + 1, row[:name][0, 35], money(row[:total]), row[:employer][0, 30], row[:occupation][0, 20],
             row[:city], row[:state], committees_str)
    end
    io.puts

    print_committee_totals(io, "DISBURSEMENTS (itemized, non-memo)", data[:disbursements][:committee_totals])
    io.puts

    print_table(io, "SPENDING BY FEC CATEGORY (all committees combined)", data[:disbursements][:by_category]) do |row, i|
      format("%2d. %-45s %12s  (n=%d)", i + 1, row[:category][0, 45], money(row[:total]), row[:count])
    end
    io.puts

    print_table(io, "TOP PAYEES (all committees combined)", data[:disbursements][:top_payees]) do |row, i|
      format("%2d. %-40s %12s  | %s, %s | category: %s", i + 1, row[:payee][0, 40], money(row[:total]), row[:city], row[:state], row[:category])
    end
    io.puts

    print_table(io, "LARGEST SINGLE DISBURSEMENTS (line items)", data[:disbursements][:top_single]) do |row, i|
      format("%2d. %-30s %12s  %s | %s, %s | %s | %s", i + 1, row[:payee][0, 30], money(row[:amount]), row[:date], row[:city], row[:state], row[:category], row[:description][0, 50])
    end

    io.string
  end

  private

  def committee_name_for(id)
    %w[schedule_a schedule_b efile].each do |schedule|
      Dir.glob(File.join(@fec_dir, id, "#{schedule}-*.csv")).each do |path|
        CSV.foreach(path, headers: true) do |row|
          return row["committee_name"].to_s.strip unless row["committee_name"].to_s.strip.empty?
        end
      end
    end
    id
  end

  def load_rows(committee, schedule)
    Dir.glob(File.join(committee.dir, "#{schedule}-*.csv")).flat_map do |path|
      CSV.read(path, headers: true).map(&:to_h)
    end
  end

  def decimal(value)
    value.to_s.strip.empty? ? BigDecimal(0) : BigDecimal(value)
  end

  def money(bd)
    format("$%.2f", bd)
  end

  def analyze_donors
    totals = Hash.new(BigDecimal(0))
    meta = {}
    committee_totals = Hash.new(BigDecimal(0))
    individual_vs_committee = Hash.new(BigDecimal(0))

    committees.each do |committee|
      load_rows(committee, "schedule_a").each do |row|
        next if row["memo_code"] == "X"
        next unless DONOR_LABELS.include?(row["line_number_label"].to_s.strip)

        amount = decimal(row["contribution_receipt_amount"])
        next if amount <= 0

        name = row["contributor_name"].to_s.strip
        next if name.empty?

        key = [name, row["contributor_employer"].to_s.strip]
        totals[key] += amount
        meta[key] ||= {
          name: name,
          employer: row["contributor_employer"].to_s.strip,
          occupation: row["contributor_occupation"].to_s.strip,
          city: row["contributor_city"].to_s.strip,
          state: row["contributor_state"].to_s.strip,
          by_committee: Hash.new(BigDecimal(0))
        }
        meta[key][:by_committee][committee.id] += amount

        committee_totals[committee.id] += amount
        individual_vs_committee[row["is_individual"] == "t" ? "individual" : "committee/PAC"] += amount
      end
    end

    top = totals.sort_by { |_k, v| -v }.first(@top).map { |key, total| meta[key].merge(total: total) }

    {
      committee_totals: committee_totals,
      individual_vs_committee: individual_vs_committee,
      top: top
    }
  end

  def analyze_disbursements
    category_totals = Hash.new(BigDecimal(0))
    category_counts = Hash.new(0)
    payee_totals = Hash.new(BigDecimal(0))
    payee_meta = {}
    committee_totals = Hash.new(BigDecimal(0))
    all_disbursements = []

    committees.each do |committee|
      load_rows(committee, "schedule_b").each do |row|
        next if row["memo_code"] == "X"

        amount = decimal(row["disbursement_amount"])
        next if amount <= 0

        category = row["category_code_full"].to_s.strip
        category = "Uncategorized" if category.empty?
        category_totals[category] += amount
        category_counts[category] += 1

        payee = row["recipient_name"].to_s.strip
        unless payee.empty?
          payee_totals[payee] += amount
          payee_meta[payee] ||= { city: row["recipient_city"].to_s.strip, state: row["recipient_state"].to_s.strip, category: category }
        end

        committee_totals[committee.id] += amount

        all_disbursements << {
          committee: committee.id,
          payee: payee,
          city: row["recipient_city"].to_s.strip,
          state: row["recipient_state"].to_s.strip,
          amount: amount,
          date: row["disbursement_date"].to_s,
          description: row["disbursement_description"].to_s.strip,
          category: category
        }
      end
    end

    {
      committee_totals: committee_totals,
      by_category: category_totals.sort_by { |_k, v| -v }.first(@top).map { |cat, total| { category: cat, total: total, count: category_counts[cat] } },
      top_payees: payee_totals.sort_by { |_k, v| -v }.first(@top).map { |payee, total| payee_meta[payee].merge(payee: payee, total: total) },
      top_single: all_disbursements.sort_by { |r| -r[:amount] }.first(@top)
    }
  end

  def print_committee_totals(io, title, totals)
    io.puts "=" * 80
    io.puts title
    io.puts "=" * 80
    committees.each do |c|
      io.puts "#{c.name} [#{c.id}]: #{money(totals[c.id])}"
    end
  end

  def print_table(io, title, rows)
    io.puts "=" * 80
    io.puts title
    io.puts "=" * 80
    rows.each_with_index { |row, i| io.puts(yield(row, i)) }
  end
end

# ---------------------------------------------------------------------------
# House Ethics Committee PDF disclosures (best-effort text mining)
# ---------------------------------------------------------------------------

class HouseEthicsScanner
  # Matches dollar amounts and ranges as they appear in FD/PTR asset tables, e.g.
  # "$1,001 - $15,000" or "$50,000" — used to pull out lines likely to be asset/
  # transaction rows worth a human's attention, out of pages of form boilerplate.
  AMOUNT_LINE = /\$[\d,]+/.freeze

  def initialize(dir)
    @dir = dir
  end

  def run
    Dir.glob(File.join(@dir, "*.pdf")).sort.map do |path|
      text = extract_text(path)
      { file: File.basename(path), asset_lines: text.lines.map(&:strip).select { |l| l.match?(AMOUNT_LINE) } }
    end
  end

  def to_text(filings)
    io = StringIO.new
    filings.each do |filing|
      io.puts "=" * 80
      io.puts filing[:file]
      io.puts "=" * 80
      if filing[:asset_lines].empty?
        io.puts "(no dollar-amount lines found — inspect the PDF directly, it may be an extension request or cover page)"
      else
        filing[:asset_lines].each { |l| io.puts "  #{l}" }
      end
      io.puts
    end
    io.string
  end

  private

  def extract_text(path)
    PDF::Reader.new(path).pages.map(&:text).join("\n")
  rescue PDF::Reader::MalformedPDFError => e
    "(unreadable PDF: #{e.message})"
  end
end

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

if $PROGRAM_NAME == __FILE__
  options = { top: 15, format: "text" }

  OptionParser.new do |opts|
    opts.banner = "Usage: analyze-candidate.rb --fec-dir DIR [options]"
    opts.on("--fec-dir DIR", "Candidate's fec/ directory (one subdirectory per committee ID, containing schedule_a-*.csv / schedule_b-*.csv)") { |v| options[:fec_dir] = v }
    opts.on("--house-ethics-dir DIR", "Candidate's house-ethics/ directory of PDF disclosures (optional)") { |v| options[:house_ethics_dir] = v }
    opts.on("--top N", Integer, "Rows per top-N table (default 15)") { |v| options[:top] = v }
    opts.on("--format FORMAT", %w[text json], "Output format: text (default) or json") { |v| options[:format] = v }
    opts.on("--out FILE", "Write output to FILE instead of stdout") { |v| options[:out] = v }
    opts.on("-h", "--help", "Show this help") do
      puts opts
      exit
    end
  end.parse!

  abort "analyze-candidate.rb: --fec-dir is required (see --help)" unless options[:fec_dir]
  abort "analyze-candidate.rb: no such directory #{options[:fec_dir]}" unless Dir.exist?(options[:fec_dir])

  fec = FecAnalyzer.new(options[:fec_dir], top: options[:top])
  fec_data = fec.run

  house_ethics_data = nil
  if options[:house_ethics_dir]
    abort "analyze-candidate.rb: no such directory #{options[:house_ethics_dir]}" unless Dir.exist?(options[:house_ethics_dir])
    house_ethics_data = HouseEthicsScanner.new(options[:house_ethics_dir]).run
  end

  output =
    if options[:format] == "json"
      # BigDecimal isn't JSON-native; round-trip through Float for portability.
      round_floats = lambda do |obj|
        case obj
        when BigDecimal then obj.to_f
        when Hash then obj.transform_values { |v| round_floats.call(v) }
        when Array then obj.map { |v| round_floats.call(v) }
        else obj
        end
      end
      payload = { fec: round_floats.call(fec_data) }
      payload[:house_ethics] = house_ethics_data if house_ethics_data
      JSON.pretty_generate(payload)
    else
      out = fec.to_text(fec_data)
      if house_ethics_data
        out += "\n"
        out += HouseEthicsScanner.new(options[:house_ethics_dir]).to_text(house_ethics_data)
      end
      out
    end

  if options[:out]
    File.write(options[:out], output)
  else
    puts output
  end
end
