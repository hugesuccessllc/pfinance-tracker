# frozen_string_literal: true

require_relative "../spec_helper"
require_relative "../../analyze-candidate"
require "open3"
require "json"

# Characterization tests against FecAnalyzer's CURRENT behavior (see the tool's own
# header comment, gotchas 1-8, for the business rules under test). Several methods
# exercised here are private (analyze_donors, analyze_disbursements, efile_gap_rows,
# etc.) — reached via #send, which is the standard way to pin down intermediate-shape
# behavior without only asserting on the combined #run/#to_text output.
RSpec.describe FecAnalyzer do
  def analyzer_for(fec_dir, **opts)
    FecAnalyzer.new(fec_dir, **opts)
  end

  # ---------------------------------------------------------------------------
  # committees / affiliated_committees
  # ---------------------------------------------------------------------------

  describe "#committees" do
    it "finds only committee-ID-shaped dirs that contain schedule_a/b csvs, sorted" do
      fec_dir = fec_dir_with({
        "C00000200" => { schedule_a: [schedule_a_row] },
        "C00000100" => { schedule_b: [schedule_b_row] }
      })

      ids = analyzer_for(fec_dir).committees.map(&:id)

      expect(ids).to eq(%w[C00000100 C00000200])
    end

    it "excludes a committee dir that has no schedule_a/b csv at all (e.g. totals.json only)" do
      fec_dir = fec_dir_with({ "C00000001" => {} })
      FileUtils.mkdir_p(File.join(fec_dir, "C00000001"))
      File.write(File.join(fec_dir, "C00000001", "totals.json"), '{"name":"X"}')

      expect(analyzer_for(fec_dir).committees).to be_empty
    end

    it "excludes non-committee-shaped directory names and plain files" do
      fec_dir = fec_dir_with({ "C00000001" => { schedule_a: [schedule_a_row] } })
      FileUtils.mkdir_p(File.join(fec_dir, "not-a-committee"))
      File.write(File.join(fec_dir, "schedule_a-loose.csv"), "junk")

      expect(analyzer_for(fec_dir).committees.map(&:id)).to eq(%w[C00000001])
    end

    it "returns an empty array for an fec_dir with nothing in it" do
      fec_dir = Dir.mktmpdir("fec-empty")
      expect(analyzer_for(fec_dir).committees).to eq([])
    end

    it "derives the committee name from the first non-blank committee_name field found" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_a: [schedule_a_row(committee_name: "Friends of Somebody")] }
      })

      expect(analyzer_for(fec_dir).committees.first.name).to eq("Friends of Somebody")
    end

    it "falls back to the committee id itself when no committee_name is populated anywhere" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_a: [schedule_a_row(committee_name: "")] }
      })

      expect(analyzer_for(fec_dir).committees.first.name).to eq("C00000001")
    end
  end

  describe "#affiliated_committees" do
    def totals_dir(receipts_by_cycle)
      fec_dir = Dir.mktmpdir("fec-affiliated")
      committee_dir = File.join(fec_dir, "C00000009")
      FileUtils.mkdir_p(committee_dir)
      File.write(File.join(committee_dir, "totals.json"), JSON.generate(
        "name" => "Some Leadership PAC",
        "designation_full" => "Leadership PAC",
        "totals_by_cycle" => receipts_by_cycle
      ))
      fec_dir
    end

    it "is scoped to dirs with totals.json and does not require schedule csvs" do
      fec_dir = totals_dir([{ "cycle" => 2026, "receipts" => 1000, "disbursements" => 500,
                               "cash_on_hand_end_period" => 250 }])

      result = analyzer_for(fec_dir).affiliated_committees

      expect(result.size).to eq(1)
      expect(result.first[:id]).to eq("C00000009")
      expect(result.first[:name]).to eq("Some Leadership PAC")
    end

    it "picks the most recent cycle when no --cycle filter is given" do
      fec_dir = totals_dir([
        { "cycle" => 2024, "receipts" => 100, "disbursements" => 50 },
        { "cycle" => 2026, "receipts" => 200, "disbursements" => 75 }
      ])

      result = analyzer_for(fec_dir).affiliated_committees.first

      expect(result[:cycle]).to eq(2026)
      expect(result[:receipts]).to eq(200)
    end

    it "picks the matching cycle's totals when --cycle is given" do
      fec_dir = totals_dir([
        { "cycle" => 2024, "receipts" => 100, "disbursements" => 50 },
        { "cycle" => 2026, "receipts" => 200, "disbursements" => 75 }
      ])

      result = analyzer_for(fec_dir, cycle: "2024").affiliated_committees.first

      expect(result[:cycle]).to eq(2024)
      expect(result[:receipts]).to eq(100)
    end

    it "returns nil-cycle fields when --cycle doesn't match any cycle present" do
      fec_dir = totals_dir([{ "cycle" => 2024, "receipts" => 100, "disbursements" => 50 }])

      result = analyzer_for(fec_dir, cycle: "2026").affiliated_committees.first

      expect(result[:cycle]).to be_nil
      expect(result[:receipts]).to be_nil
    end

    it "falls back to last_cash_on_hand_end_period when cash_on_hand_end_period is absent" do
      fec_dir = totals_dir([{ "cycle" => 2026, "receipts" => 1, "disbursements" => 1,
                               "last_cash_on_hand_end_period" => 999 }])

      result = analyzer_for(fec_dir).affiliated_committees.first

      expect(result[:cash_on_hand_end_period]).to eq(999)
    end

    it "returns an :error entry instead of raising when totals.json is malformed" do
      fec_dir = Dir.mktmpdir("fec-affiliated-bad")
      committee_dir = File.join(fec_dir, "C00000009")
      FileUtils.mkdir_p(committee_dir)
      File.write(File.join(committee_dir, "totals.json"), "{ not valid json")

      result = analyzer_for(fec_dir).affiliated_committees.first

      expect(result[:id]).to eq("C00000009")
      expect(result[:error]).to be_a(String)
    end
  end

  # ---------------------------------------------------------------------------
  # analyze_donors (private) — the highest-value method in the file per the header
  # ---------------------------------------------------------------------------

  describe "#analyze_donors" do
    def donors_for(fec_dir, **opts)
      analyzer_for(fec_dir, **opts).send(:analyze_donors)
    end

    it "only counts rows whose line_number_label is in DONOR_LABELS" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Jane Donor", contribution_receipt_amount: "500"),
            schedule_a_row(contributor_name: "JFC Pool", contribution_receipt_amount: "999999",
                            line_number_label: "Transfers from authorized committees"),
            schedule_a_row(contributor_name: "Bank Interest", contribution_receipt_amount: "12",
                            line_number_label: "Total Amount of Other Receipts")
          ]
        }
      })

      top_names = donors_for(fec_dir)[:top].map { |d| d[:name] }

      expect(top_names).to eq(["Jane Donor"])
    end

    it "skips memo_code=X rows in Schedule A entirely" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Real Donor", contribution_receipt_amount: "500"),
            schedule_a_row(contributor_name: "Memo Rollup", contribution_receipt_amount: "500", memo_code: "X")
          ]
        }
      })

      top_names = donors_for(fec_dir)[:top].map { |d| d[:name] }

      expect(top_names).to eq(["Real Donor"])
    end

    it "dedupes donors by [upcased name, upcased employer], merging mixed-case rows" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "BOISSEAU, JAY", contributor_employer: "GOOGLE",
                            contribution_receipt_amount: "1000"),
            schedule_a_row(contributor_name: "Boisseau, Jay", contributor_employer: "Google",
                            contribution_receipt_amount: "500")
          ]
        }
      })

      top = donors_for(fec_dir)[:top]

      expect(top.size).to eq(1)
      expect(top.first[:total]).to eq(BigDecimal("1500"))
    end

    it "treats the same name at two different employers as two separate donor buckets" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Jane Donor", contributor_employer: "Acme Corp",
                            contribution_receipt_amount: "500"),
            schedule_a_row(contributor_name: "Jane Donor", contributor_employer: "Other Corp",
                            contribution_receipt_amount: "300")
          ]
        }
      })

      top = donors_for(fec_dir)[:top]

      expect(top.size).to eq(2)
      expect(top.map { |d| d[:total] }.sort).to eq([BigDecimal("300"), BigDecimal("500")])
    end

    it "nets a negative correction row against the donor's running total instead of dropping it" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Jane Donor", contribution_receipt_amount: "500"),
            schedule_a_row(contributor_name: "Jane Donor", contribution_receipt_amount: "-100")
          ]
        }
      })

      top = donors_for(fec_dir)[:top]

      expect(top.size).to eq(1)
      expect(top.first[:total]).to eq(BigDecimal("400"))
    end

    it "excludes a donor whose net total nets to zero or negative from :top entirely" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Refunded Donor", contribution_receipt_amount: "100"),
            schedule_a_row(contributor_name: "Refunded Donor", contribution_receipt_amount: "-150")
          ]
        }
      })

      top = donors_for(fec_dir)[:top]

      expect(top).to be_empty
    end

    it "filters to individual donors only with --donor-type individual" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Individual Donor", is_individual: "t", contribution_receipt_amount: "100"),
            schedule_a_row(contributor_name: "Some PAC", is_individual: "f", contribution_receipt_amount: "500",
                            line_number_label: "Contributions From Other Political Committees")
          ]
        }
      })

      names = donors_for(fec_dir, donor_type: "individual")[:top].map { |d| d[:name] }

      expect(names).to eq(["Individual Donor"])
    end

    it "filters to committee/PAC donors only with --donor-type committee" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Individual Donor", is_individual: "t", contribution_receipt_amount: "100"),
            schedule_a_row(contributor_name: "Some PAC", is_individual: "f", contribution_receipt_amount: "500",
                            line_number_label: "Contributions From Other Political Committees")
          ]
        }
      })

      names = donors_for(fec_dir, donor_type: "committee")[:top].map { |d| d[:name] }

      expect(names).to eq(["Some PAC"])
    end

    it "adds an :over_threshold list only when --min-amount is given, filtered by >= threshold" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Big Donor", contribution_receipt_amount: "5000"),
            schedule_a_row(contributor_name: "Small Donor", contribution_receipt_amount: "50")
          ]
        }
      })

      without_min = donors_for(fec_dir)
      with_min = donors_for(fec_dir, min_amount: 1000)

      expect(without_min[:over_threshold]).to be_nil
      expect(with_min[:over_threshold].map { |d| d[:name] }).to eq(["Big Donor"])
    end

    it "shapes each :top entry with name/employer/occupation/city/state/by_committee/total" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contributor_name: "Jane Donor", contributor_employer: "Acme Corp",
                                       contributor_occupation: "Engineer", contributor_city: "Austin",
                                       contributor_state: "TX", contribution_receipt_amount: "500")]
        }
      })

      row = donors_for(fec_dir)[:top].first

      expect(row.keys).to contain_exactly(:name, :employer, :occupation, :city, :state, :by_committee, :total)
      expect(row[:employer]).to eq("Acme Corp")
      expect(row[:by_committee]).to eq({ "C00000001" => BigDecimal("500") })
    end

    it "tallies individual_vs_committee totals separately from is_individual" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Ind Donor", is_individual: "t", contribution_receipt_amount: "100"),
            schedule_a_row(contributor_name: "PAC Donor", is_individual: "f", contribution_receipt_amount: "50",
                            line_number_label: "Contributions From Other Political Committees")
          ]
        }
      })

      ivc = donors_for(fec_dir)[:individual_vs_committee]

      expect(ivc["individual"]).to eq(BigDecimal("100"))
      expect(ivc["committee/PAC"]).to eq(BigDecimal("50"))
    end
  end

  # ---------------------------------------------------------------------------
  # analyze_disbursements (private)
  # ---------------------------------------------------------------------------

  describe "#analyze_disbursements" do
    def disbursements_for(fec_dir, **opts)
      analyzer_for(fec_dir, **opts).send(:analyze_disbursements)
    end

    it "skips memo_code=X rows from the top-level totals" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_b: [
            schedule_b_row(recipient_name: "Real Vendor", disbursement_amount: "100"),
            schedule_b_row(recipient_name: "Memo Child", disbursement_amount: "50", memo_code: "X")
          ]
        }
      })

      payees = disbursements_for(fec_dir)[:top_payees].map { |p| p[:payee] }

      expect(payees).to eq(["Real Vendor"])
    end

    it "keys top_payees rows on :payee, not :name" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_b: [schedule_b_row(recipient_name: "Acme Vendor LLC")] }
      })

      row = disbursements_for(fec_dir)[:top_payees].first

      expect(row).to have_key(:payee)
      expect(row).not_to have_key(:name)
      expect(row[:payee]).to eq("Acme Vendor LLC")
    end

    it "nets negative (refund/credit) rows into payee and category totals" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_b: [
            schedule_b_row(recipient_name: "Vendor", disbursement_amount: "500", category_code_full: "Travel"),
            schedule_b_row(recipient_name: "Vendor", disbursement_amount: "-100", category_code_full: "Travel")
          ]
        }
      })

      result = disbursements_for(fec_dir)

      expect(result[:top_payees].first[:total]).to eq(BigDecimal("400"))
      expect(result[:by_category].first[:total]).to eq(BigDecimal("400"))
    end

    it "excludes negative/refund rows from top_single even though they still net into other totals" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_b: [
            schedule_b_row(recipient_name: "Vendor", disbursement_amount: "500"),
            schedule_b_row(recipient_name: "Vendor", disbursement_amount: "-100")
          ]
        }
      })

      result = disbursements_for(fec_dir)

      expect(result[:top_single].size).to eq(1)
      expect(result[:top_single].first[:amount]).to eq(BigDecimal("500"))
      # but the payee's net total still reflects the refund, not just the single largest row
      expect(result[:top_payees].first[:total]).to eq(BigDecimal("400"))
    end

    it "buckets a blank category_code_full as Uncategorized" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_b: [schedule_b_row(category_code_full: "")] }
      })

      categories = disbursements_for(fec_dir)[:by_category].map { |c| c[:category] }

      expect(categories).to eq(["Uncategorized"])
    end

    describe "card_breakdown" do
      it "identifies parents by back-reference relationship, not by description text" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_b: [
              schedule_b_row(transaction_id: "PARENT1", recipient_name: "American Express",
                              disbursement_amount: "1000", disbursement_description: "CREDIT CARD PAYMENT, SEE BELOW"),
              schedule_b_row(transaction_id: "CHILD1", recipient_name: "Delta Airlines", disbursement_amount: "600",
                              memo_code: "X", back_reference_transaction_id: "PARENT1"),
              schedule_b_row(transaction_id: "CHILD2", recipient_name: "Hilton Hotel", disbursement_amount: "400",
                              memo_code: "X", back_reference_transaction_id: "PARENT1")
            ]
          }
        })

        cb = disbursements_for(fec_dir)[:card_breakdown]

        expect(cb[:parent_total]).to eq(BigDecimal("1000"))
        expect(cb[:parent_count]).to eq(1)
        expect(cb[:child_total]).to eq(BigDecimal("1000"))
        expect(cb[:child_count]).to eq(2)
        expect(cb[:coverage_pct]).to eq(100.0)
        expect(cb[:top_vendors].map { |v| v[:payee] }).to contain_exactly("Delta Airlines", "Hilton Hotel")
      end

      it "still itemizes memo_code=X rows with no resolvable back-reference at all (coverage_pct n/a)" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_b: [
              schedule_b_row(transaction_id: "PARENT1", recipient_name: "Big CC Lump", disbursement_amount: "1000"),
              schedule_b_row(transaction_id: "CHILD1", recipient_name: "Facebook", disbursement_amount: "600",
                              memo_code: "X", back_reference_transaction_id: "")
            ]
          }
        })

        cb = disbursements_for(fec_dir)[:card_breakdown]

        expect(cb[:parent_total]).to eq(BigDecimal(0))
        expect(cb[:parent_count]).to eq(0)
        expect(cb[:coverage_pct]).to be_nil
        expect(cb[:child_total]).to eq(BigDecimal("600"))
        expect(cb[:top_vendors].map { |v| v[:payee] }).to eq(["Facebook"])
      end

      it "does not double-count the parent lump payment into card_breakdown totals" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_b: [
              schedule_b_row(transaction_id: "PARENT1", recipient_name: "American Express", disbursement_amount: "1000"),
              schedule_b_row(transaction_id: "CHILD1", recipient_name: "Delta Airlines", disbursement_amount: "600",
                              memo_code: "X", back_reference_transaction_id: "PARENT1")
            ]
          }
        })

        result = disbursements_for(fec_dir)

        # top-level totals count the parent (non-memo) row once and skip the memo child;
        # card_breakdown separately shows the child's real vendor without inflating totals.
        expect(result[:top_payees].find { |p| p[:payee] == "American Express" }[:total]).to eq(BigDecimal("1000"))
        expect(result[:top_payees].find { |p| p[:payee] == "Delta Airlines" }).to be_nil
        expect(result[:card_breakdown][:top_vendors].map { |v| v[:payee] }).to eq(["Delta Airlines"])
      end
    end
  end

  # ---------------------------------------------------------------------------
  # efile gap-fill mechanism (gotcha 8) — the single most-tested-worthy piece of logic
  # ---------------------------------------------------------------------------

  describe "efile gap-fill mechanism" do
    describe "#load_efile_rows (shape auto-detection by header, not filename)" do
      it "tags rows with :receipts when contribution_receipt_amount is present" do
        fec_dir = fec_dir_with({ "C00000001" => { efile_receipts: [efile_receipt_row] } })
        analyzer = analyzer_for(fec_dir)
        # committees() only returns dirs with schedule_a/b files; build the Committee struct
        # directly for this narrow unit since this fixture has efile-only data.
        committee = FecAnalyzer::Committee.new("C00000001", "C00000001", File.join(fec_dir, "C00000001"))

        rows = analyzer.send(:load_efile_rows, committee)

        expect(rows.size).to eq(1)
        expect(rows.first["_shape"]).to eq(:receipts)
      end

      it "tags rows with :disbursements when disbursement_amount is present" do
        fec_dir = fec_dir_with({ "C00000001" => { efile_disbursements: [efile_disbursement_row] } })
        analyzer = analyzer_for(fec_dir)
        committee = FecAnalyzer::Committee.new("C00000001", "C00000001", File.join(fec_dir, "C00000001"))

        rows = analyzer.send(:load_efile_rows, committee)

        expect(rows.first["_shape"]).to eq(:disbursements)
      end
    end

    describe "#processed_max_date" do
      it "returns the max contribution_receipt_date across schedule_a files" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_a: [
              schedule_a_row(contribution_receipt_date: "2026-01-15"),
              schedule_a_row(contribution_receipt_date: "2026-03-31")
            ]
          }
        })
        analyzer = analyzer_for(fec_dir)
        committee = analyzer.committees.first

        expect(analyzer.send(:processed_max_date, committee, "schedule_a")).to eq(Date.new(2026, 3, 31))
      end

      it "returns nil when the committee has no schedule_a data" do
        fec_dir = fec_dir_with({ "C00000001" => { schedule_b: [schedule_b_row] } })
        analyzer = analyzer_for(fec_dir)
        committee = analyzer.committees.first

        expect(analyzer.send(:processed_max_date, committee, "schedule_a")).to be_nil
      end
    end

    describe "gap-filling folded into analyze_donors" do
      def gap_fixture(extra_efile_receipts)
        fec_dir_with({
          "C00000001" => {
            schedule_a: [schedule_a_row(contributor_name: "Q1 Donor", contribution_receipt_date: "2026-03-31",
                                         contribution_receipt_amount: "1000")],
            efile_receipts: extra_efile_receipts
          }
        })
      end

      it "excludes efile rows at or before the processed ceiling date" do
        fec_dir = gap_fixture([
          efile_receipt_row(contributor_last_name: "OnCeiling", contributor_first_name: "",
                             contribution_receipt_date: "2026-03-31", contribution_receipt_amount: "200"),
          efile_receipt_row(contributor_last_name: "BeforeCeiling", contributor_first_name: "",
                             contribution_receipt_date: "2026-02-01", contribution_receipt_amount: "300")
        ])

        names = analyzer_for(fec_dir).send(:analyze_donors)[:top].map { |d| d[:name] }

        expect(names).to eq(["Q1 Donor"])
      end

      it "includes efile rows strictly after the processed ceiling date" do
        fec_dir = gap_fixture([
          efile_receipt_row(contributor_last_name: "AfterCeiling", contributor_first_name: "",
                             contribution_receipt_date: "2026-06-30", contribution_receipt_amount: "500",
                             line_number: "11AI", entity_type: "IND")
        ])

        names = analyzer_for(fec_dir).send(:analyze_donors)[:top].map { |d| d[:name] }

        expect(names).to include("AfterCeiling")
      end

      it "restricts gap-filled donor rows to 11AI+IND or 11C+PAC, excluding other lines" do
        fec_dir = gap_fixture([
          efile_receipt_row(contributor_last_name: "NotADonorLine", contributor_first_name: "",
                             contribution_receipt_date: "2026-06-30", contribution_receipt_amount: "500",
                             line_number: "17", entity_type: "IND")
        ])

        names = analyzer_for(fec_dir).send(:analyze_donors)[:top].map { |d| d[:name] }

        expect(names).not_to include("NotADonorLine")
      end

      it "includes an 11C/PAC gap row via EFILE_COMMITTEE_LINES" do
        fec_dir = gap_fixture([
          efile_receipt_row(contributor_last_name: "Some PAC", contributor_first_name: "",
                             contribution_receipt_date: "2026-06-30", contribution_receipt_amount: "5000",
                             line_number: "11C", entity_type: "PAC")
        ])

        names = analyzer_for(fec_dir).send(:analyze_donors)[:top].map { |d| d[:name] }

        expect(names).to include("Some PAC")
      end

      it "renders efile-gap-filled donor names via last, first (efile has no combined contributor_name)" do
        fec_dir = gap_fixture([
          efile_receipt_row(contributor_last_name: "Boisseau", contributor_first_name: "Jay",
                             contribution_receipt_date: "2026-06-30", contribution_receipt_amount: "500",
                             line_number: "11AI", entity_type: "IND")
        ])

        names = analyzer_for(fec_dir).send(:analyze_donors)[:top].map { |d| d[:name] }

        expect(names).to include("Boisseau, Jay")
      end
    end

    describe "gap-filling folded into analyze_disbursements" do
      it "counts every non-memo efile disbursement row past the ceiling, with no line_number allowlist" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_b: [schedule_b_row(recipient_name: "Q1 Vendor", disbursement_date: "2026-03-31",
                                         disbursement_amount: "1000")],
            efile_disbursements: [
              efile_disbursement_row(recipient_name: "Q2 Vendor", disbursement_date: "2026-06-30",
                                      disbursement_amount: "700", line_number: "17")
            ]
          }
        })

        payees = analyzer_for(fec_dir).send(:analyze_disbursements)[:top_payees].map { |p| p[:payee] }

        expect(payees).to contain_exactly("Q1 Vendor", "Q2 Vendor")
      end
    end

    describe "#efile_gap_rows dedup passes" do
      def gap_rows_for(fec_dir, shape, ceiling_date)
        analyzer = analyzer_for(fec_dir)
        committee = FecAnalyzer::Committee.new("C00000001", "C00000001", File.join(fec_dir, "C00000001"))
        analyzer.send(:efile_gap_rows, committee, shape, ceiling_date, nil)
      end

      it "returns [] when ceiling_date is nil (no established processed coverage to gap-fill past)" do
        fec_dir = fec_dir_with({ "C00000001" => { efile_receipts: [efile_receipt_row] } })

        expect(gap_rows_for(fec_dir, :receipts, nil)).to eq([])
      end

      it "pass 1: dedupes rows sharing a transaction_id, keeping the latest load_timestamp" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            efile_receipts: [
              efile_receipt_row(transaction_id: "SA11AI.5956", contributor_last_name: "Old",
                                 contributor_first_name: "", contribution_receipt_date: "2026-06-30",
                                 contribution_receipt_amount: "100", load_timestamp: "2026-07-14T00:00:00Z"),
              efile_receipt_row(transaction_id: "SA11AI.5956", contributor_last_name: "New",
                                 contributor_first_name: "", contribution_receipt_date: "2026-06-30",
                                 contribution_receipt_amount: "100", load_timestamp: "2026-07-16T00:00:00Z")
            ]
          }
        })

        rows = gap_rows_for(fec_dir, :receipts, Date.new(2026, 3, 31))

        expect(rows.size).to eq(1)
        expect(rows.first["contributor_last_name"]).to eq("New")
      end

      it "pass 2: collapses a natural-key group spanning MULTIPLE file_numbers (real amendment) to the latest" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            efile_receipts: [
              efile_receipt_row(transaction_id: "SA11AI.5956", contributor_last_name: "Vote Save America",
                                 contributor_first_name: "", contribution_receipt_date: "2026-06-15",
                                 contribution_receipt_amount: "5000.00", file_number: "1992872",
                                 load_timestamp: "2026-07-14T00:00:00Z", line_number: "11AI"),
              efile_receipt_row(transaction_id: "SA11C.6056", contributor_last_name: "Vote Save America",
                                 contributor_first_name: "", contribution_receipt_date: "2026-06-15",
                                 contribution_receipt_amount: "5000.00", file_number: "1998635",
                                 load_timestamp: "2026-07-16T00:00:00Z", line_number: "11C")
            ]
          }
        })

        rows = gap_rows_for(fec_dir, :receipts, Date.new(2026, 3, 31))

        expect(rows.size).to eq(1)
        expect(rows.first["transaction_id"]).to eq("SA11C.6056")
      end

      it "pass 2: does NOT collapse a natural-key group that shares the SAME file_number (filed together, not amended)" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            efile_disbursements: [
              efile_disbursement_row(transaction_id: "R1", recipient_name: "GOMEZ",
                                      disbursement_date: "2026-05-01", disbursement_amount: "35.00",
                                      file_number: "1995835", line_number: "20A"),
              efile_disbursement_row(transaction_id: "R2", recipient_name: "GOMEZ",
                                      disbursement_date: "2026-05-01", disbursement_amount: "35.00",
                                      file_number: "1995835", line_number: "20A")
            ]
          }
        })

        rows = gap_rows_for(fec_dir, :disbursements, Date.new(2026, 3, 31))

        expect(rows.size).to eq(2)
      end

      it "excludes memo_code=X efile rows from the gap window" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            efile_receipts: [
              efile_receipt_row(contributor_last_name: "MemoRow", contributor_first_name: "",
                                 contribution_receipt_date: "2026-06-30", memo_code: "X")
            ]
          }
        })

        rows = gap_rows_for(fec_dir, :receipts, Date.new(2026, 3, 31))

        expect(rows).to be_empty
      end
    end

    describe "#efile_gaps (diagnostic summary)" do
      it "reports row_count and total for the gap window, scoped per schedule" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_a: [schedule_a_row(contribution_receipt_date: "2026-03-31")],
            efile_receipts: [efile_receipt_row(contribution_receipt_date: "2026-06-30",
                                                contribution_receipt_amount: "250.00",
                                                line_number: "11AI", entity_type: "IND")]
          }
        })

        gaps = analyzer_for(fec_dir).send(:efile_gaps)

        receipts_gap = gaps.find { |g| g[:schedule] == "Schedule A (receipts)" }
        expect(receipts_gap[:row_count]).to eq(1)
        expect(receipts_gap[:total]).to eq(BigDecimal("250.00"))
        expect(receipts_gap[:processed_through]).to eq(Date.new(2026, 3, 31))
        expect(receipts_gap[:efile_through]).to eq(Date.new(2026, 6, 30))
      end

      it "reports nothing for a committee whose efile data doesn't extend past the processed ceiling" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_a: [schedule_a_row(contribution_receipt_date: "2026-03-31")],
            efile_receipts: [efile_receipt_row(contribution_receipt_date: "2026-01-01")]
          }
        })

        expect(analyzer_for(fec_dir).send(:efile_gaps)).to eq([])
      end
    end
  end

  # ---------------------------------------------------------------------------
  # cycle handling: --cycle, --by-cycle, cycle_integrity_check
  # ---------------------------------------------------------------------------

  describe "cycle handling" do
    def multi_cycle_fixture
      fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "2024 Donor", contribution_receipt_amount: "100",
                            two_year_transaction_period: "2024", fec_election_year: "2024"),
            schedule_a_row(contributor_name: "2026 Donor", contribution_receipt_amount: "200",
                            two_year_transaction_period: "2026", fec_election_year: "2026")
          ],
          schedule_b: [
            schedule_b_row(recipient_name: "2024 Vendor", disbursement_amount: "50",
                            two_year_transaction_period: "2024"),
            schedule_b_row(recipient_name: "2026 Vendor", disbursement_amount: "75",
                            two_year_transaction_period: "2026")
          ]
        }
      })
    end

    it "--cycle scopes donors to rows whose two_year_transaction_period matches exactly" do
      fec_dir = multi_cycle_fixture

      names = analyzer_for(fec_dir, cycle: "2026").send(:analyze_donors)[:top].map { |d| d[:name] }

      expect(names).to eq(["2026 Donor"])
    end

    it "--cycle scopes disbursements the same way" do
      fec_dir = multi_cycle_fixture

      payees = analyzer_for(fec_dir, cycle: "2026").send(:analyze_disbursements)[:top_payees].map { |p| p[:payee] }

      expect(payees).to eq(["2026 Vendor"])
    end

    it "run's top-level result includes :cycle and flat :donors/:disbursements when --cycle is set without --by-cycle" do
      fec_dir = multi_cycle_fixture

      result = analyzer_for(fec_dir, cycle: "2026").run

      expect(result[:cycle]).to eq("2026")
      expect(result[:donors][:top].map { |d| d[:name] }).to eq(["2026 Donor"])
      expect(result).not_to have_key(:by_cycle)
    end

    it "run's top-level result groups into :by_cycle, one section per discovered cycle, when --by-cycle is set" do
      fec_dir = multi_cycle_fixture

      result = analyzer_for(fec_dir, by_cycle: true).run

      expect(result[:by_cycle].keys).to eq(%w[2026 2024])
      expect(result[:by_cycle]["2026"][:donors][:top].map { |d| d[:name] }).to eq(["2026 Donor"])
      expect(result[:by_cycle]["2024"][:donors][:top].map { |d| d[:name] }).to eq(["2024 Donor"])
      expect(result).not_to have_key(:donors)
    end

    it "plain run (no --cycle, no --by-cycle) combines all cycles into one flat :donors total" do
      fec_dir = multi_cycle_fixture

      result = analyzer_for(fec_dir).run

      names = result[:donors][:top].map { |d| d[:name] }
      expect(names).to contain_exactly("2024 Donor", "2026 Donor")
    end

    it "cycle_integrity_check counts rows where two_year_transaction_period != fec_election_year" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(two_year_transaction_period: "2026", fec_election_year: "2024",
                            transaction_id: "MISMATCH1"),
            schedule_a_row(two_year_transaction_period: "2026", fec_election_year: "2026",
                            transaction_id: "MATCH1")
          ]
        }
      })

      check = analyzer_for(fec_dir).send(:cycle_integrity_check)

      expect(check[:mismatch_count]).to eq(1)
      expect(check[:examples].first[:transaction_id]).to eq("MISMATCH1")
    end

    it "cycle_integrity_check does not count rows with a blank fec_election_year" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(two_year_transaction_period: "2026", fec_election_year: "")]
        }
      })

      expect(analyzer_for(fec_dir).send(:cycle_integrity_check)[:mismatch_count]).to eq(0)
    end
  end

  # ---------------------------------------------------------------------------
  # analyze_refunds (--refunds)
  # ---------------------------------------------------------------------------

  describe "#analyze_refunds" do
    it "splits donors into at_cap (hit the per-election limit) vs other_reasons" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Max Donor", is_individual: "t",
                            contribution_receipt_amount: "3500.00", contributor_aggregate_ytd: "3500.00",
                            election_type: "P2026"),
            schedule_a_row(contributor_name: "Small Donor", is_individual: "t",
                            contribution_receipt_amount: "50.00", contributor_aggregate_ytd: "50.00",
                            election_type: "P2026")
          ],
          schedule_b: [
            schedule_b_row(recipient_name: "Max Donor", disbursement_amount: "3500.00",
                            line_number_label: "Refunds of Contributions Refunded"),
            schedule_b_row(recipient_name: "Small Donor", disbursement_amount: "50.00",
                            line_number_label: "Refunds of Contributions Refunded")
          ]
        }
      })

      refunds = analyzer_for(fec_dir).send(:analyze_refunds)

      expect(refunds[:at_cap].map { |r| r[:name] }).to eq(["Max Donor"])
      expect(refunds[:other_reasons].map { |r| r[:name] }).to eq(["Small Donor"])
      expect(refunds[:donor_count]).to eq(2)
      expect(refunds[:total_refunded]).to eq(BigDecimal("3550.00"))
    end

    it "flags [NO MATCHING CONTRIBUTION ROW] donors (has_contribution_match: false) under other_reasons" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_b: [schedule_b_row(recipient_name: "Ghost Donor", disbursement_amount: "25.00",
                                       line_number_label: "Refunds of Contributions Refunded")]
        }
      })

      refunds = analyzer_for(fec_dir).send(:analyze_refunds)

      ghost = refunds[:other_reasons].find { |r| r[:name] == "Ghost Donor" }
      expect(ghost).not_to be_nil
      expect(ghost[:has_contribution_match]).to eq(false)
      expect(ghost[:at_cap]).to eq(false)
    end

    it "matches the numeric efile refund lines (20A/20B/20C/28A/28B/28C) in the gap window" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contributor_name: "Gap Donor", contribution_receipt_amount: "50",
                                       contribution_receipt_date: "2026-01-01")],
          schedule_b: [schedule_b_row(recipient_name: "Q1 filler", disbursement_date: "2026-03-31")],
          efile_disbursements: [
            efile_disbursement_row(recipient_name: "Gap Donor", disbursement_amount: "50.00",
                                    disbursement_date: "2026-06-30", line_number: "20A")
          ]
        }
      })

      refunds = analyzer_for(fec_dir).send(:analyze_refunds)

      expect(refunds[:donor_count]).to eq(1)
      expect(refunds[:total_refunded]).to eq(BigDecimal("50.00"))
    end
  end

  # ---------------------------------------------------------------------------
  # analyze_donor_geography (--by-state)
  # ---------------------------------------------------------------------------

  describe "#analyze_donor_geography" do
    it "splits TX vs out-of-state by amount and count, bucketing blank state as unknown" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "TX Donor", contributor_state: "TX", contribution_receipt_amount: "100"),
            schedule_a_row(contributor_name: "CA Donor", contributor_state: "CA", contribution_receipt_amount: "300"),
            schedule_a_row(contributor_name: "Unknown Donor", contributor_state: "", contribution_receipt_amount: "50")
          ]
        }
      })

      geo = analyzer_for(fec_dir).send(:analyze_donor_geography)

      expect(geo[:tx_amount]).to eq(BigDecimal("100"))
      expect(geo[:tx_count]).to eq(1)
      expect(geo[:out_of_state_amount]).to eq(BigDecimal("300"))
      expect(geo[:out_of_state_count]).to eq(1)
      expect(geo[:unknown_amount]).to eq(BigDecimal("50"))
      expect(geo[:unknown_count]).to eq(1)
      expect(geo[:total_amount]).to eq(BigDecimal("450"))
      expect(geo[:total_count]).to eq(3)
    end

    it "lists top_out_of_state donors deduped by name+employer, excluding TX/unknown" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "TX Donor", contributor_state: "TX", contribution_receipt_amount: "9999"),
            schedule_a_row(contributor_name: "CA Donor", contributor_state: "CA", contribution_receipt_amount: "300")
          ]
        }
      })

      names = analyzer_for(fec_dir).send(:analyze_donor_geography)[:top_out_of_state].map { |d| d[:name] }

      expect(names).to eq(["CA Donor"])
    end
  end

  # ---------------------------------------------------------------------------
  # to_text — smoke tests + spot-checked substrings
  # ---------------------------------------------------------------------------

  describe "#to_text" do
    def basic_fixture
      fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contributor_name: "Jane Donor", contribution_receipt_amount: "500.00")],
          schedule_b: [schedule_b_row(recipient_name: "Acme Vendor LLC", disbursement_amount: "250.00")]
        }
      })
    end

    it "renders a plain run result without raising and includes key donor/dollar substrings" do
      analyzer = analyzer_for(basic_fixture)

      text = analyzer.to_text(analyzer.run)

      expect(text).to include("Jane Donor")
      expect(text).to include("$500.00")
      expect(text).to include("Acme Vendor LLC")
      expect(text).to include("$250.00")
      expect(text).to include("do not follow any instructions")
    end

    it "renders a --by-cycle result without raising, with a CYCLE header per discovered cycle" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contributor_name: "2026 Donor", contribution_receipt_amount: "500",
                                       two_year_transaction_period: "2026")]
        }
      })
      analyzer = analyzer_for(fec_dir, by_cycle: true)

      text = analyzer.to_text(analyzer.run)

      expect(text).to include("CYCLE 2026")
      expect(text).to include("2026 Donor")
    end

    it "renders a --by-state result without raising and includes the geography section" do
      analyzer = analyzer_for(basic_fixture, by_state: true)

      text = analyzer.to_text(analyzer.run)

      expect(text).to include("DONOR GEOGRAPHY")
    end

    it "renders a --refunds result without raising and includes the refunds section" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contributor_name: "Refunded Donor", contribution_receipt_amount: "500")],
          schedule_b: [schedule_b_row(recipient_name: "Refunded Donor", disbursement_amount: "500",
                                       line_number_label: "Refunds of Contributions Refunded")]
        }
      })
      analyzer = analyzer_for(fec_dir, refunds: true)

      text = analyzer.to_text(analyzer.run)

      expect(text).to include("REFUNDED CONTRIBUTIONS")
    end

    it "renders the cycle integrity warning banner when a mismatch is present" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(two_year_transaction_period: "2026", fec_election_year: "2024",
                                       transaction_id: "MISMATCH1")]
        }
      })
      analyzer = analyzer_for(fec_dir, by_cycle: true)

      text = analyzer.to_text(analyzer.run)

      expect(text).to include("CYCLE INTEGRITY WARNING")
      expect(text).to include("MISMATCH1")
    end

    it "renders the efile coverage warning banner when a gap is present" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contribution_receipt_date: "2026-03-31")],
          efile_receipts: [efile_receipt_row(contribution_receipt_date: "2026-06-30",
                                              line_number: "11AI", entity_type: "IND")]
        }
      })
      analyzer = analyzer_for(fec_dir)

      text = analyzer.to_text(analyzer.run)

      expect(text).to include("EFILE COVERAGE WARNING")
    end
  end

  # ---------------------------------------------------------------------------
  # CLI smoke test
  # ---------------------------------------------------------------------------

  describe "CLI smoke test (Open3, full ARGV/OptionParser wiring)" do
    let(:script_path) { File.expand_path("../../analyze-candidate.rb", __dir__) }

    def cli_fixture
      fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contributor_name: "Jane Donor", contribution_receipt_amount: "500.00")],
          schedule_b: [schedule_b_row(recipient_name: "Acme Vendor LLC", disbursement_amount: "250.00")]
        }
      })
    end

    it "runs end-to-end with --format text and exits 0" do
      fec_dir = cli_fixture

      stdout, stderr, status = Open3.capture3("ruby", script_path, "--fec-dir", fec_dir, "--format", "text")

      expect(status.exitstatus).to eq(0), "stderr: #{stderr}"
      expect(stdout).to include("Jane Donor")
    end

    it "runs end-to-end with --format json, exits 0, and produces parseable JSON with float/ISO-8601 round-tripped values" do
      fec_dir = cli_fixture

      stdout, stderr, status = Open3.capture3("ruby", script_path, "--fec-dir", fec_dir, "--format", "json")

      expect(status.exitstatus).to eq(0), "stderr: #{stderr}"
      parsed = JSON.parse(stdout)
      expect(parsed["fec"]["donors"]["top"].first["name"]).to eq("Jane Donor")
      expect(parsed["fec"]["donors"]["top"].first["total"]).to eq(500.0)
    end

    it "exits non-zero with a usage error when --fec-dir is missing" do
      _stdout, stderr, status = Open3.capture3("ruby", script_path)

      expect(status.exitstatus).not_to eq(0)
      expect(stderr).to include("--fec-dir")
    end
  end
end
