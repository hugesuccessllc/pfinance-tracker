# frozen_string_literal: true

require "csv"

# Builds throwaway fec/<committee-id>/ directory trees shaped like real FEC exports
# (schedule_a-*.csv, schedule_b-*.csv, efile-*.csv), using only the columns the tools
# actually read (verified against `grep -ohE 'row\["[a-z_]+"\]'` across tooling/*.rb) —
# not the 70+ column real export header. CSV#[] returns nil for any column a fixture
# omits, which is fine: every tool already treats missing/blank fields as absent data.
#
# Usage in a spec:
#   fec_dir = fec_dir_with("C00000001" => {
#     schedule_a: [schedule_a_row(contributor_name: "Jane Donor", contribution_receipt_amount: "500")],
#     schedule_b: [schedule_b_row(recipient_name: "Acme Catering", disbursement_amount: "250")]
#   })
module FixtureHelpers
  # A single Schedule A (receipts) row, as it appears in fec.gov's processed
  # schedule_a-*.csv export. Override any column via keyword args.
  def schedule_a_row(overrides = {})
    {
      "committee_id" => "C00000001",
      "committee_name" => "TEST FOR CONGRESS",
      "transaction_id" => "SA_#{rand(1_000_000)}",
      "entity_type" => "IND",
      "contributor_name" => "Doe, Jane",
      "contributor_first_name" => "Jane",
      "contributor_middle_name" => "",
      "contributor_last_name" => "Doe",
      "contributor_city" => "Austin",
      "contributor_state" => "TX",
      "contributor_employer" => "Acme Corp",
      "contributor_occupation" => "Engineer",
      "is_individual" => "t",
      "memo_code" => "",
      "memo_text" => "",
      "contribution_receipt_date" => "2026-01-15",
      "contribution_receipt_amount" => "100.00",
      "contributor_aggregate_ytd" => "100.00",
      "two_year_transaction_period" => "2026",
      "line_number_label" => "Contributions From Individuals/Persons Other Than Political Committees",
      "load_timestamp" => "2026-01-16T00:00:00Z"
    }.merge(stringify_keys(overrides))
  end

  # A single Schedule B (disbursements) row, as it appears in fec.gov's processed
  # schedule_b-*.csv export.
  def schedule_b_row(overrides = {})
    {
      "committee_id" => "C00000001",
      "committee_name" => "TEST FOR CONGRESS",
      "transaction_id" => "SB_#{rand(1_000_000)}",
      "recipient_name" => "Acme Vendor LLC",
      "recipient_city" => "Washington",
      "recipient_state" => "DC",
      "disbursement_description" => "CATERING",
      "disbursement_purpose_category" => "Other",
      "category_code_full" => "Administrative",
      "memo_code" => "",
      "memo_text" => "",
      "disbursement_date" => "2026-01-15",
      "disbursement_amount" => "100.00",
      "two_year_transaction_period" => "2026"
    }.merge(stringify_keys(overrides))
  end

  # A raw efile row shaped like the receipts-side efile-*.csv (has
  # contribution_receipt_amount, no schedule_a-only columns like line_number_label).
  def efile_receipt_row(overrides = {})
    {
      "line_number" => "11AI",
      "committee_name" => "TEST FOR CONGRESS",
      "committee_id" => "C00000001",
      "contributor_first_name" => "Jane",
      "contributor_middle_name" => "",
      "contributor_last_name" => "Doe",
      "contributor_name" => "Doe, Jane",
      "contributor_city" => "Austin",
      "contributor_state" => "TX",
      "contributor_employer" => "Acme Corp",
      "contributor_occupation" => "Engineer",
      "contribution_receipt_amount" => "100.00",
      "contribution_receipt_date" => "2026-07-01",
      "transaction_id" => "EF_SA_#{rand(1_000_000)}",
      "entity_type" => "IND",
      "memo_code" => "",
      "memo_text" => "",
      "load_timestamp" => "2026-07-02T00:00:00Z"
    }.merge(stringify_keys(overrides))
  end

  # A raw efile row shaped like the disbursements-side efile-*.csv (has
  # disbursement_amount, no schedule_b-only columns like disbursement_purpose_category).
  def efile_disbursement_row(overrides = {})
    {
      "line_number" => "17",
      "committee_name" => "TEST FOR CONGRESS",
      "committee_id" => "C00000001",
      "recipient_name" => "Acme Vendor LLC",
      "recipient_city" => "Washington",
      "recipient_state" => "DC",
      "disbursement_description" => "CATERING",
      "disbursement_date" => "2026-07-01",
      "disbursement_amount" => "100.00",
      "transaction_id" => "EF_SB_#{rand(1_000_000)}",
      "entity_type" => "",
      "memo_code" => "",
      "memo_text" => ""
    }.merge(stringify_keys(overrides))
  end

  # Writes `rows` (array of column-name => value hashes, e.g. from schedule_a_row) to
  # `path` as a CSV with a header row taken from the union of all rows' keys.
  def write_csv(path, rows)
    headers = rows.flat_map(&:keys).uniq
    CSV.open(path, "w") do |csv|
      csv << headers
      rows.each { |row| csv << headers.map { |h| row[h] } }
    end
  end

  # Builds a full fec/ directory tree in a fresh temp dir and returns its path.
  #
  #   fec_dir_with(
  #     "C00000001" => {
  #       schedule_a: [schedule_a_row(...), ...],
  #       schedule_b: [schedule_b_row(...), ...],
  #       efile_receipts: [efile_receipt_row(...), ...],
  #       efile_disbursements: [efile_disbursement_row(...), ...]
  #     }
  #   )
  #
  # Any key may be omitted; only the files for keys present are written. `filename_suffix`
  # lets a spec force filenames apart when writing more than one schedule_a/schedule_b file
  # for the same committee (real candidate dirs accumulate several timestamped exports).
  def fec_dir_with(committees, filename_suffix: "2026-01-01T00_00_00Z")
    dir = Dir.mktmpdir("fec-fixture")
    committees.each do |committee_id, files|
      committee_dir = File.join(dir, committee_id)
      FileUtils.mkdir_p(committee_dir)

      write_csv(File.join(committee_dir, "schedule_a-#{filename_suffix}.csv"), files[:schedule_a]) if files[:schedule_a]
      write_csv(File.join(committee_dir, "schedule_b-#{filename_suffix}.csv"), files[:schedule_b]) if files[:schedule_b]
      write_csv(File.join(committee_dir, "efile-#{filename_suffix}-receipts.csv"), files[:efile_receipts]) if files[:efile_receipts]
      write_csv(File.join(committee_dir, "efile-#{filename_suffix}-disbursements.csv"), files[:efile_disbursements]) if files[:efile_disbursements]
    end
    dir
  end

  def stringify_keys(hash)
    hash.transform_keys(&:to_s)
  end
end
