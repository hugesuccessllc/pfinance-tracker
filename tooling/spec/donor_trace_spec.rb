# frozen_string_literal: true

# Characterization specs for donor-trace.rb — pinning down current behavior, with a bias
# toward the data-integrity gotchas in that file's header (the ones that produce a
# plausible-looking wrong answer rather than a crash).

require_relative "spec_helper"
require_relative "../donor-trace"

RSpec.describe "donor-trace.rb" do
  # A JFC receipt: the donor actually parting with money.
  def jfc_check(overrides = {})
    schedule_a_row({
      "committee_id" => "C00000901",
      "committee_name" => "TEST VICTORY FUND",
      "contributor_name" => "ANWAR, SYED JAVAID",
      "contribution_receipt_amount" => "332100.00",
      "contribution_receipt_date" => "2025-02-07",
      "transaction_id" => "SRC1"
    }.merge(stringify_keys(overrides)))
  end

  # The non-memo transfer row a participant files when a JFC sends it money.
  def transfer_in(overrides = {})
    schedule_a_row({
      "committee_id" => "C00000902",
      "committee_name" => "TEST FOR CONGRESS",
      "contributor_name" => "TEST VICTORY FUND",
      "contribution_receipt_amount" => "50000.00",
      "contribution_receipt_date" => "2025-02-26",
      "transaction_id" => "XFER1",
      "line_number_label" => "Transfers from authorized committees",
      "memo_code" => ""
    }.merge(stringify_keys(overrides)))
  end

  # The memo attribution row naming the original donor inside that transfer.
  def landing(overrides = {})
    schedule_a_row({
      "committee_id" => "C00000902",
      "committee_name" => "TEST FOR CONGRESS",
      "contributor_name" => "ANWAR, SYED JAVAID",
      "contribution_receipt_amount" => "3500.00",
      "contribution_receipt_date" => "2025-02-07",
      "transaction_id" => "LAND1",
      "line_number_label" => "Transfers from authorized committees",
      "memo_code" => "X",
      "back_reference_transaction_id" => "XFER1",
      "fec_election_type_desc" => "PRIMARY"
    }.merge(stringify_keys(overrides)))
  end

  describe "source and landing separation" do
    it "counts the JFC check as a source and the memo row as a landing, never both" do
      dir = fec_dir_with({
        "C00000901" => { schedule_a: [jfc_check] },
        "C00000902" => { schedule_a: [transfer_in, landing] }
      })

      result = build_result(dir, ["anwar"], "2026")

      expect(result[:sources].sum(&:amount)).to eq(BigDecimal("332100"))
      expect(result[:landings].sum(&:amount)).to eq(BigDecimal("3500"))
      expect(result[:sources].map(&:committee_id)).to eq(["C00000901"])
      expect(result[:landings].map(&:committee_id)).to eq(["C00000902"])
    end

    it "resolves the landing's parent transfer via back_reference_transaction_id" do
      dir = fec_dir_with({
        "C00000901" => { schedule_a: [jfc_check] },
        "C00000902" => { schedule_a: [transfer_in, landing] }
      })

      landed = build_result(dir, ["anwar"], "2026")[:landings].first
      expect(landed.via_committee).to eq("TEST VICTORY FUND")
      expect(landed.via_transfer_date).to eq("2025-02-26")
    end

    it "reports an unresolvable back-reference as (unlinked) rather than dropping the row" do
      dir = fec_dir_with({
        "C00000901" => { schedule_a: [jfc_check] },
        "C00000902" => { schedule_a: [landing("back_reference_transaction_id" => "NOPE")] }
      })

      landed = build_result(dir, ["anwar"], "2026")[:landings]
      expect(landed.size).to eq(1)
      expect(landed.first.via_committee).to eq("(unlinked)")
    end
  end

  # Gotcha 1: real Pfluger data spells this label two different ways across two of his own
  # committees. An exact-string match finds zero landings in one of them and looks like a
  # clean "nothing traced" result instead of a bug.
  describe "transfer label matching (gotcha 1)" do
    it "matches the transfer line label case-insensitively" do
      dir = fec_dir_with({
        "C00000901" => { schedule_a: [jfc_check] },
        "C00000902" => {
          schedule_a: [
            transfer_in("line_number_label" => "Transfers from Authorized Committees"),
            landing("line_number_label" => "Transfers from Authorized Committees")
          ]
        }
      })

      expect(build_result(dir, ["anwar"], "2026")[:landings].sum(&:amount)).to eq(BigDecimal("3500"))
    end
  end

  # Gotcha 2: per-election limits are separate, so one check legitimately produces two
  # same-committee, same-donor, same-amount landing rows. Deduping them would halve the trace.
  describe "per-election landings (gotcha 2)" do
    it "keeps primary and general attribution rows as distinct landings" do
      dir = fec_dir_with({
        "C00000901" => { schedule_a: [jfc_check] },
        "C00000902" => {
          schedule_a: [
            transfer_in,
            landing("transaction_id" => "LAND_P", "fec_election_type_desc" => "PRIMARY"),
            landing("transaction_id" => "LAND_G", "fec_election_type_desc" => "GENERAL")
          ]
        }
      })

      landings = build_result(dir, ["anwar"], "2026")[:landings]
      expect(landings.size).to eq(2)
      expect(landings.sum(&:amount)).to eq(BigDecimal("7000"))
      expect(landings.map(&:election)).to contain_exactly("PRIMARY", "GENERAL")
    end
  end

  # Gotcha 6: a partnership's contribution is attributed to its partners as memo rows on the
  # DONOR side. They carry memo_code=X like a landing does, but sit under a donor line label.
  # Counting them as sources double-counts the LP check; counting them as landings invents
  # money that never moved between committees.
  describe "partnership attribution rows (gotcha 6)" do
    it "excludes donor-side memo attributions from both sources and landings" do
      dir = fec_dir_with({
        "C00000901" => {
          schedule_a: [
            jfc_check("contributor_name" => "RCA ENERGY LP", "contribution_receipt_amount" => "24000.00",
                      "transaction_id" => "LP1", "entity_type" => "ORG", "is_individual" => "f"),
            jfc_check("contributor_name" => "ANWAR, RYAN", "contribution_receipt_amount" => "12000.00",
                      "transaction_id" => "LPMEMO1", "memo_code" => "X",
                      "back_reference_transaction_id" => "")
          ]
        }
      })

      result = build_result(dir, ["anwar"], "2026")
      expect(result[:sources]).to be_empty
      expect(result[:landings]).to be_empty
    end
  end

  describe "cycle scoping (gotcha 7)" do
    it "excludes rows outside the requested two_year_transaction_period" do
      dir = fec_dir_with({
        "C00000901" => {
          schedule_a: [jfc_check, jfc_check("transaction_id" => "OLD",
                                            "two_year_transaction_period" => "2024")]
        }
      })

      expect(build_result(dir, ["anwar"], "2026")[:sources].size).to eq(1)
      expect(build_result(dir, ["anwar"], nil)[:sources].size).to eq(2)
    end
  end

  describe "reconciliation" do
    it "reports the untraced residual as received minus traced" do
      dir = fec_dir_with({
        "C00000901" => { schedule_a: [jfc_check] },
        "C00000902" => { schedule_a: [transfer_in, landing] }
      })

      recon = build_result(dir, ["anwar"], "2026")[:reconciliation].first
      expect(recon[:received]).to eq(BigDecimal("332100"))
      expect(recon[:traced]).to eq(BigDecimal("3500"))
      expect(recon[:residual]).to eq(BigDecimal("328600"))
    end

    it "lists the source JFC's committee transfer recipients as residual destinations" do
      dir = fec_dir_with({
        "C00000901" => {
          schedule_a: [jfc_check],
          schedule_b: [
            schedule_b_row("recipient_name" => "NRCC", "recipient_committee_id" => "C00075820",
                           "disbursement_amount" => "310000.00"),
            # No recipient_committee_id: a vendor, not a participant. Must not be listed.
            schedule_b_row("recipient_name" => "ACME CATERING", "disbursement_amount" => "500.00")
          ]
        }
      })

      dests = build_result(dir, ["anwar"], "2026")[:transfers_out]["C00000901"]
      expect(dests.map(&:recipient_name)).to eq(["NRCC"])
      expect(dests.first.amount).to eq(BigDecimal("310000"))
    end
  end

  describe "donor matching" do
    it "matches contributor_name case-insensitively on a substring" do
      dir = fec_dir_with({ "C00000901" => { schedule_a: [jfc_check] } })
      expect(build_result(dir, ["syed javaid"], "2026")[:sources].size).to eq(1)
      expect(build_result(dir, ["nobody"], "2026")[:sources]).to be_empty
    end

    it "treats a full 'LAST, FIRST' needle as one substring, not two" do
      dir = fec_dir_with({
        "C00000901" => {
          schedule_a: [jfc_check, jfc_check("contributor_name" => "ANWAR, RYAN C.",
                                            "transaction_id" => "SRC2")]
        }
      })

      result = build_result(dir, ["anwar, syed javaid"], "2026")
      expect(result[:sources].map(&:contributor_name)).to eq(["ANWAR, SYED JAVAID"])
    end
  end
end
