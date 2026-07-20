#!/usr/bin/env ruby
# frozen_string_literal: true

# vendor-keyword-scan.rb — line-referenced keyword search over a candidate's Schedule B
# (disbursements) data.
#
# analyze-candidate.rb answers "who got paid the most, in what category." This tool
# answers a narrower question: "show me every disbursement row whose vendor name or
# description matches one of these keywords, with an exact file + line number for each,
# so a human/LLM can cite it." Useful for building a themed spending report (e.g. dining,
# lodging, gifts) where you need to point a reader at the receipt, not just a total.
#
# Like analyze-candidate.rb, this script does NOT editorialize — it prints matched rows
# and per-keyword-group subtotals, nothing else. Grouping keywords into meaningful
# categories and writing prose about what the pattern means is the caller's job.
#
# USAGE
#   ruby tooling/vendor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec \
#     --group "Fine Dining=capital grille,del frisco,oceanaire,tosca" \
#     --group "Lodging=hilton,marriott,ritz,st. regis,four seasons"
#
#   ruby tooling/vendor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec \
#     --keywords "steakhouse,chophouse" --format json
#
# LINE NUMBERS: this script reads each schedule_b-*.csv with Ruby's CSV#lineno, which
# counts physical lines consumed (correctly handles multi-line quoted fields), NOT the
# logical row index. The reported line number is the exact line a human would land on
# opening the CSV in a text editor or running `sed -n '<line>p' <file>`. Line 1 is always
# the header row.
#
# CAVEATS (read before trusting a total)
#   - This is a plain case-insensitive substring match against recipient_name,
#     disbursement_description, and memo_text. It will both over-match (a keyword like
#     "grille" could hit an unrelated vendor with that substring) and under-match (a
#     misspelled or differently-formatted vendor name won't hit). Spot-check matches
#     against the source CSV before publishing a total built from this tool.
#   - memo_code=X rows are the itemized children of a lump card payment (see
#     analyze-candidate.rb's header, gotcha 1) — their disbursement_amount is already
#     excluded from their parent's total elsewhere, so summing matched rows here (memo
#     and non-memo alike) does not double-count against analyze-candidate.rb's totals.
#   - Negative amounts are corrections/refunds (same gotcha as analyze-candidate.rb) —
#     they're included in the match list (so a correction to a matched vendor is visible)
#     but flagged with a leading "-" rather than silently dropped or silently netted.
#   - Only reads schedule_b-*.csv (disbursements) by default. Does not read efile-*.csv,
#     per analyze-candidate.rb's existing rationale (same transactions, different shape,
#     reading both double-counts).
#
# EFILE GAP (--include-efile-gap)
#   fec.gov's schedule_b-*.csv is a "processed" export — it lags behind the raw efile
#   submissions a campaign actually files, sometimes by months (observed gap on Pfluger's
#   principal committee and JFC: schedule_b stopped at 2026-03-31 while the raw efile
#   already had itemized disbursements through 2026-06-30). A report built from schedule_b
#   alone can silently miss the most recent quarter of spending.
#
#   --include-efile-gap does NOT merge efile and schedule_b wholesale (spot-checking found
#   efile transaction_ids do not reliably match schedule_b's for the same underlying
#   transaction, so naive deduping by transaction_id is not safe — see the double-count
#   warning above). Instead, per committee, it finds schedule_b's own latest
#   disbursement_date and pulls ONLY rows from the committee's disbursement-shaped
#   efile-*.csv (identified by having a disbursement_amount column, as opposed to the
#   contribution_receipt_amount-shaped receipts efile) dated STRICTLY AFTER that date —
#   a window schedule_b provably has zero rows in, so there is no overlap to double-count.
#   These rows are marked with an "[efile, not yet in processed export]" tag in text output
#   (or "source": "efile-gap" in JSON) so a reader can tell which numbers come from the
#   normal processed export versus the raw, not-yet-reconciled filing data.

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("Gemfile", __dir__)
require "bundler/setup"

require "csv"
require "optparse"
require "json"
require "bigdecimal"

options = { fec_dir: nil, groups: {}, cycle: nil, format: "text", out: nil, include_efile_gap: false }

OptionParser.new do |opts|
  opts.banner = "Usage: vendor-keyword-scan.rb --fec-dir DIR (--group \"Name=kw1,kw2\" | --keywords kw1,kw2) [options]"
  opts.on("--fec-dir DIR", "Candidate's fec/ directory") { |v| options[:fec_dir] = v }
  opts.on("--group SPEC", "Named keyword group as Name=kw1,kw2,... (repeatable)") do |v|
    name, kws = v.split("=", 2)
    raise OptionParser::InvalidArgument, v if name.nil? || kws.nil?
    options[:groups][name] = kws.split(",").map(&:strip)
  end
  opts.on("--keywords LIST", "Comma-separated keywords, grouped under 'Matches'") do |v|
    options[:groups]["Matches"] = v.split(",").map(&:strip)
  end
  opts.on("--cycle YYYY", "Scope to a single two_year_transaction_period") { |v| options[:cycle] = v }
  opts.on("--include-efile-gap", "Also scan raw efile-*.csv rows dated after schedule_b's latest date (see header comment)") do
    options[:include_efile_gap] = true
  end
  opts.on("--format FORMAT", "text (default) or json") { |v| options[:format] = v }
  opts.on("--out FILE", "Write output to FILE instead of stdout") { |v| options[:out] = v }
  opts.on("-h", "--help", "Show this help") do
    puts opts
    exit
  end
end.parse!

if options[:fec_dir].nil? || options[:groups].empty?
  warn "Error: --fec-dir and at least one of --group/--keywords are required. See --help."
  exit 1
end

Match = Struct.new(:group, :keyword, :committee_id, :committee_name, :file, :line, :date,
                    :recipient_name, :recipient_city, :recipient_state, :amount,
                    :description, :category, :memo_code, :transaction_id, :source, keyword_init: true)

def committees(fec_dir)
  Dir.children(fec_dir)
     .select { |d| d =~ /\AC\d{6,}\z/ && File.directory?(File.join(fec_dir, d)) }
     .sort
end

# The efile-*.csv naming convention doesn't distinguish receipts-shaped from
# disbursements-shaped files — only the header does. A committee's receipts-shaped efile
# (contribution_receipt_amount) is irrelevant here; we only want the disbursement-shaped one.
def disbursement_efile_paths(committee_dir)
  Dir.glob(File.join(committee_dir, "efile-*.csv")).select do |path|
    File.open(path) { |f| f.readline }.include?("disbursement_amount")
  end
end

def schedule_b_max_date(committee_dir)
  max_date = nil
  Dir.glob(File.join(committee_dir, "schedule_b-*.csv")).each do |path|
    File.open(path) do |f|
      csv = CSV.new(f, headers: true)
      while (row = csv.shift)
        d = row["disbursement_date"].to_s
        max_date = d if d > max_date.to_s
      end
    end
  end
  max_date
end

def scan_rows(csv_enum, options, matches, cid, committee_dir_label, source:, min_date_exclusive: nil)
  while (row = csv_enum.next_row)
    next if options[:cycle] && row["two_year_transaction_period"].to_s.strip != options[:cycle].to_s
    date = row["disbursement_date"].to_s
    next if min_date_exclusive && date <= min_date_exclusive

    haystack = [row["recipient_name"], row["disbursement_description"], row["memo_text"]].join(" ").downcase

    options[:groups].each do |group_name, keywords|
      hit = keywords.find { |kw| haystack.include?(kw.downcase) }
      next unless hit

      matches << Match.new(
        group: group_name,
        keyword: hit,
        committee_id: cid,
        committee_name: row["committee_name"],
        file: csv_enum.path,
        line: csv_enum.lineno,
        date: row["disbursement_date"],
        recipient_name: row["recipient_name"],
        recipient_city: row["recipient_city"],
        recipient_state: row["recipient_state"],
        amount: BigDecimal(row["disbursement_amount"].to_s),
        description: row["disbursement_description"],
        category: row["category_code_full"] || row["disbursement_purpose_category"],
        memo_code: row["memo_code"],
        transaction_id: row["transaction_id"],
        source: source
      )
      break # first matching group wins per row; avoid double-listing one row under two groups
    end
  end
end

# Thin wrapper pairing a CSV with its own path, since Match needs to report the file it
# came from and plain CSV#lineno alone doesn't carry that.
PathedCsv = Struct.new(:path, :csv) do
  def next_row
    csv.shift
  end

  def lineno
    csv.lineno
  end
end

matches = []

committees(options[:fec_dir]).each do |cid|
  committee_dir = File.join(options[:fec_dir], cid)

  Dir.glob(File.join(committee_dir, "schedule_b-*.csv")).each do |path|
    File.open(path) do |f|
      scan_rows(PathedCsv.new(path, CSV.new(f, headers: true)), options, matches, cid, committee_dir, source: "schedule_b")
    end
  end

  next unless options[:include_efile_gap]

  max_date = schedule_b_max_date(committee_dir)
  next if max_date.nil? # no schedule_b baseline to compare against; skip rather than guess

  disbursement_efile_paths(committee_dir).each do |path|
    File.open(path) do |f|
      scan_rows(PathedCsv.new(path, CSV.new(f, headers: true)), options, matches, cid, committee_dir,
                source: "efile-gap", min_date_exclusive: max_date)
    end
  end
end

matches.sort_by! { |m| [m.group, -m.amount] }

output =
  if options[:format] == "json"
    JSON.pretty_generate(
      matches.group_by(&:group).transform_values do |rows|
        {
          total: rows.sum(&:amount).to_s("F"),
          count: rows.size,
          rows: rows.map { |m| m.to_h.merge(amount: m.amount.to_s("F")) }
        }
      end
    )
  else
    buf = +""
    matches.group_by(&:group).each do |group_name, rows|
      buf << ("=" * 80) << "\n"
      buf << "#{group_name} — #{rows.size} row(s), $#{'%.2f' % rows.sum(&:amount)}\n"
      buf << ("=" * 80) << "\n"
      rows.each do |m|
        sign = m.amount.negative? ? "-" : ""
        tags = [(" [memo/card sub-item]" if m.memo_code == "X"),
                (" [efile, not yet in processed export]" if m.source == "efile-gap")].compact.join
        buf << format(
          "%-45s $%s%9.2f  %s | %s, %s | %s:%d | %s%s\n",
          m.recipient_name.to_s[0, 45],
          sign, m.amount.abs,
          m.date.to_s[0, 10],
          m.recipient_city, m.recipient_state,
          m.file.sub("#{Dir.pwd}/", ""), m.line,
          m.description,
          tags
        )
      end
      efile_gap_rows = rows.select { |m| m.source == "efile-gap" }
      unless efile_gap_rows.empty?
        buf << format("  (of which %d row(s), $%.2f, from efile data not yet in a processed schedule_b export)\n",
                       efile_gap_rows.size, efile_gap_rows.sum(&:amount))
      end
      buf << "\n"
    end
    buf
  end

if options[:out]
  File.write(options[:out], output)
else
  puts output
end
