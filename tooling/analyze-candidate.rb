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
# This file only reads schedule_a-*.csv (receipts) and schedule_b-*.csv (disbursements) —
# fec.gov's "processed" bulk exports. Each committee directory also tends to accumulate
# efile-*.csv files (the campaign's raw electronic submission) from re-running the FEC
# export UI — DO NOT glob those in here. They cover largely the same transactions as
# schedule_a/schedule_b in a different shape, and reading both would double-count. If you
# ever need the raw efile data for a field schedule_a/b doesn't carry, join it in as a
# separate pass rather than summing across both file sets.
#
# FEC's processed schedule_a/schedule_b exports appear to already resolve amendments —
# in the committees checked so far, transaction_id is unique per file except for a couple
# of memo/non-memo pairs (see point 1), so a superseded-then-amended transaction does NOT
# show up as two competing live rows. Don't assume this holds for every committee, though:
# before trusting a new candidate's totals, spot-check for repeated transaction_id values
# (`amendment_indicator` "C"/"D" rows are the ones most likely to have a still-present
# original) and net them out if you find any.
#
# Two more gotchas will silently double- or under-count money if you naively SUM(amount):
#
#   1. memo_code == "X" marks a line as informational-only for FEC's own report totals —
#      but what that means for YOUR aggregate depends on which schedule you're in:
#      - Schedule A: the memo row is a redundant rollup (e.g. a WinRed/conduit "earmarked"
#        line whose back_reference_transaction_id points at the real, already-itemized
#        individual donor row). Excluding it is correct and loses no information.
#      - Schedule B: the memo rows are very often the ONLY place the real vendor-level
#        detail lives. A committee reports one lump non-memo payment to a card processor
#        (e.g. "AMERICAN EXPRESS") and then dozens to hundreds of memo_code=X child rows —
#        each with a real recipient_name (an airline, a hotel, a caterer) and
#        back_reference_transaction_id pointing at that parent — giving the actual itemized
#        purchases. Excluding memo rows keeps the DOLLAR TOTAL correct (summing parent +
#        children would double it), but throwing the children away entirely erases the only
#        merchant-level detail that exists for that spending. Don't call this kind of lump
#        payment a "black box" without first checking for back-referenced children — see
#        analyze_card_breakdown below, which surfaces them separately so the total stays
#        accurate AND the detail isn't lost.
#
#        IMPORTANT: identify the parent row by the back-reference relationship itself
#        (a non-memo row whose transaction_id some memo_code=X row's
#        back_reference_transaction_id points at) — NOT by matching disbursement_description
#        text like "SEE MEMO ITEMS". That text is committee-specific: August Pfluger's
#        (TX-11) committees mostly use it, but Greg Casar's (TX-37) use "CREDIT CARD
#        PAYMENT, SEE BELOW" for the identical structure. Text-matching silently drops real
#        lump payments for committees that phrase it differently — the back-reference check
#        caught 35 more of Pfluger's own lump payments (worth ~$18.8k) that text-matching
#        had missed, so this isn't just a Casar fix.
#
#        Some filers (John Carter's, TX-31, is the one that surfaced this) never populate
#        back_reference_transaction_id at all — every memo_code=X row in the file has it
#        blank, so the back-reference check finds zero parents/children even though the
#        memo rows are full of real merchant names (e.g. hundreds of individual FACEBOOK,
#        SOUTHWEST AIRLINE, H-E-B rows). analyze_card_breakdown therefore treats EVERY
#        memo_code=X row in Schedule B as itemized vendor detail regardless of whether it
#        has a resolvable back-reference, and only uses back-referenced rows to compute the
#        parent_total/coverage_pct stats (which report as 0/n/a when no back-references
#        exist — an honest "can't verify against a lump total," not a guess).
#
#   2. Negative amounts are corrections (chargebacks, reattributions, refunds), not noise
#      — drop the row (`next if amount <= 0`) and you'll overstate whoever the correction
#      applies to; net it into their running total instead. This script sums every
#      non-memo, in-scope row per donor/payee/category, positive or negative, and only
#      then ranks the resulting totals — it does not filter rows by sign before summing.
#      (The one place row-level sign filtering is still correct is the "largest single
#      disbursements" list, which is deliberately asking "biggest individual outflows",
#      not "net total for this payee".)
#
#   3. Schedule A's `line_number_label` column tells you what KIND of receipt a row is,
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
# read, not a fully-parsed dataset — verify anything you cite against the source PDF. Also
# watch for amended PTRs: a member can refile a corrected Periodic Transaction Report, and
# an original + its amendment describing the same trade would double-count if you summed
# "number of trades" or dollar ranges across every PDF in the directory. Check each PDF's
# own filing-type/status text (and matching dates across filings) before treating two
# filings as two distinct transactions.

require "csv"
require "bigdecimal"
require "json"
require "optparse"
require "stringio"
require "set"
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
    io.puts

    cb = data[:disbursements][:card_breakdown]
    io.puts "=" * 80
    io.puts "CARD / BULK PAYMENT BREAKDOWN (memo sub-items behind \"SEE MEMO ITEMS\" lump payments)"
    io.puts "=" * 80
    io.puts "#{cb[:parent_count]} lump payment(s) totaling #{money(cb[:parent_total])}; " \
            "#{cb[:child_count]} itemized memo sub-transaction(s) totaling #{money(cb[:child_total])} " \
            "(#{cb[:coverage_pct] || "n/a"}% of the lump total is itemized at the vendor level below)."
    io.puts
    io.puts "Top vendors within these lump payments:"
    cb[:top_vendors].each_with_index do |row, i|
      io.puts format("%2d. %-40s %12s  | %s, %s", i + 1, row[:payee][0, 40], money(row[:total]), row[:city], row[:state])
    end
    io.puts
    io.puts "By category within these lump payments:"
    cb[:by_category].each_with_index do |row, i|
      io.puts format("%2d. %-45s %12s", i + 1, row[:category][0, 45], money(row[:total]))
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

        # Sum every in-scope row, positive or negative — chargebacks/reattributions net
        # against the donor's other gifts rather than being silently discarded.
        amount = decimal(row["contribution_receipt_amount"])

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

    top = totals.select { |_k, v| v > 0 }.sort_by { |_k, v| -v }.first(@top).map { |key, total| meta[key].merge(total: total) }

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

        # Sum every non-memo row, positive or negative — vendor credits/refunds net
        # against that vendor's other charges rather than being silently discarded.
        amount = decimal(row["disbursement_amount"])

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

        # Largest-single-transaction view deliberately looks at individual outflows, not
        # net-per-payee, so it filters to positive line items only (see strategy note 2).
        next if amount <= 0

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
      by_category: category_totals.select { |_k, v| v > 0 }.sort_by { |_k, v| -v }.first(@top).map { |cat, total| { category: cat, total: total, count: category_counts[cat] } },
      top_payees: payee_totals.select { |_k, v| v > 0 }.sort_by { |_k, v| -v }.first(@top).map { |payee, total| payee_meta[payee].merge(payee: payee, total: total) },
      top_single: all_disbursements.sort_by { |r| -r[:amount] }.first(@top),
      card_breakdown: analyze_card_breakdown
    }
  end

  # Surfaces the real vendor-level detail hiding inside lump/bulk payments (typically
  # credit-card processors) whose memo_code=X children back-reference them — see strategy
  # note 1 above. Reported separately from top_payees/by_category so the primary totals
  # stay correct (parent + children would double-count).
  #
  # Parents (where identifiable) are found by the back-reference relationship itself (any
  # non-memo row that a memo_code=X child points at via back_reference_transaction_id), NOT
  # by matching disbursement_description text like "SEE MEMO ITEMS". That text varies by
  # committee — e.g. Greg Casar's (TX-37) committees use "CREDIT CARD PAYMENT, SEE BELOW"
  # for the same structure — so text-matching silently drops real lump payments for some
  # candidates.
  #
  # Every memo_code=X row is counted as itemized vendor detail regardless of whether it
  # has a resolvable back-reference — some filers (John Carter's, TX-31) never populate
  # back_reference_transaction_id at all, but the memo rows still carry real merchant
  # names. When no back-referenced parents exist, parent_total/parent_count stay 0 and
  # coverage_pct reports nil ("n/a") rather than guessing at a lump total to compare against.
  def analyze_card_breakdown
    vendor_totals = Hash.new(BigDecimal(0))
    vendor_meta = {}
    category_totals = Hash.new(BigDecimal(0))
    parent_total = BigDecimal(0)
    parent_count = 0
    child_total = BigDecimal(0)
    child_count = 0

    committees.each do |committee|
      rows = load_rows(committee, "schedule_b")
      memo_rows = rows.select { |r| r["memo_code"] == "X" }
      next if memo_rows.empty?

      referenced_ids = memo_rows.map { |r| r["back_reference_transaction_id"] }
                                 .reject { |v| v.to_s.strip.empty? }.to_set
      parents = rows.select { |r| r["memo_code"] != "X" && referenced_ids.include?(r["transaction_id"]) }
      parents.each { |r| parent_total += decimal(r["disbursement_amount"]); parent_count += 1 }

      memo_rows.each do |row|
        amount = decimal(row["disbursement_amount"])
        child_total += amount
        child_count += 1

        payee = row["recipient_name"].to_s.strip
        unless payee.empty?
          vendor_totals[payee] += amount
          vendor_meta[payee] ||= { city: row["recipient_city"].to_s.strip, state: row["recipient_state"].to_s.strip }
        end

        category = row["category_code_full"].to_s.strip
        category = "Uncategorized" if category.empty?
        category_totals[category] += amount
      end
    end

    {
      parent_total: parent_total,
      parent_count: parent_count,
      child_total: child_total,
      child_count: child_count,
      coverage_pct: parent_total.zero? ? nil : (child_total / parent_total * 100).to_f.round(1),
      top_vendors: vendor_totals.select { |_k, v| v > 0 }.sort_by { |_k, v| -v }.first(@top).map { |payee, total| vendor_meta[payee].merge(payee: payee, total: total) },
      by_category: category_totals.select { |_k, v| v > 0 }.sort_by { |_k, v| -v }.first(@top).map { |cat, total| { category: cat, total: total } }
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
