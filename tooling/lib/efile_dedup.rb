# frozen_string_literal: true

# The second (natural-key) dedup pass for raw efile gap rows, shared by analyze-candidate.rb,
# donor-keyword-scan.rb, and vendor-keyword-scan.rb so the three can't drift apart again.
# See analyze-candidate.rb gotcha 8 for the full story; the short version:
#
# - A natural-key group (same date, amount, counterparty) whose rows all share ONE
#   file_number was filed together in one submission. Those are separate transactions and
#   all of them count. Pfluger's C00719294 Q3 2026 efile has three distinct $6,674.08
#   InterContinental Willard lodging charges on 2026-07-05, and the GOMEZ refund batch in
#   gotcha 8 has five separate $35.00 rows. Collapsing either group to one row undercounts.
# - A group spanning MORE THAN ONE file_number is an original plus a later correction (the
#   VOTE SAVE AMERICA re-filing under a new transaction_id). Keep every row from the newest
#   filing in the group (the file_number of its latest load_timestamp) and drop the rest. That
#   way a genuine repeat inside the corrected filing still survives.
#
# Run this only after the transaction_id pass (latest load_timestamp per id), as all three
# callers do.
module EfileDedup
  module_function

  # items: any array; row_of: item -> CSV row (needs file_number/load_timestamp);
  # key: item -> natural key. Returns the surviving items, group order preserved.
  def collapse_natural_key_groups(items, row_of:, key:)
    items.group_by(&key).flat_map do |_, group|
      file_numbers = group.map { |item| row_of.call(item)["file_number"].to_s }.uniq
      next group if file_numbers.size <= 1

      newest = row_of.call(group.max_by { |item| row_of.call(item)["load_timestamp"].to_s })["file_number"].to_s
      group.select { |item| row_of.call(item)["file_number"].to_s == newest }
    end
  end
end
