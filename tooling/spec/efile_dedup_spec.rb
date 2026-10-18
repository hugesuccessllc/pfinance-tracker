# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../lib/efile_dedup"

RSpec.describe EfileDedup do
  def row(file_number, load_timestamp, txn)
    { "file_number" => file_number, "load_timestamp" => load_timestamp, "transaction_id" => txn }
  end

  def collapse(rows)
    EfileDedup.collapse_natural_key_groups(rows, row_of: ->(r) { r }, key: ->(_r) { :same_key })
  end

  it "keeps every row of a natural-key group filed together in one file_number" do
    # Three distinct $6,674.08 Willard lodging charges on one date, one filing.
    rows = [row("2028678", "2026-10-16", "B6AF"), row("2028678", "2026-10-16", "BDB2"),
            row("2028678", "2026-10-16", "BE3B")]

    expect(collapse(rows).map { |r| r["transaction_id"] }).to eq(%w[B6AF BDB2 BE3B])
  end

  it "keeps only the newest filing's rows when a group spans file_numbers" do
    # The VOTE SAVE AMERICA case: re-filed under a new transaction_id in a later filing.
    rows = [row("1992872", "2026-07-14", "SA11AI.5956"), row("1998635", "2026-07-16", "SA11C.6056")]

    expect(collapse(rows).map { |r| r["transaction_id"] }).to eq(["SA11C.6056"])
  end

  it "keeps a genuine repeat inside the newest filing when the group spans file_numbers" do
    rows = [row("1", "2026-07-14", "OLD"), row("2", "2026-07-16", "NEW-A"), row("2", "2026-07-16", "NEW-B")]

    expect(collapse(rows).map { |r| r["transaction_id"] }).to eq(%w[NEW-A NEW-B])
  end
end
