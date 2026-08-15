# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../donor-keyword-scan"
require "open3"
require "json"
require "bigdecimal"

RSpec.describe "donor-keyword-scan.rb" do
  let(:script_path) { File.expand_path("../donor-keyword-scan.rb", __dir__) }

  describe "#committees" do
    it "returns only C-prefixed 6+ digit directories, sorted, excluding non-matching names and non-directories" do
      fec_dir = fec_dir_with({ "C00000002" => {}, "C00000001" => {} })
      FileUtils.mkdir_p(File.join(fec_dir, "C123")) # too few digits, excluded
      File.write(File.join(fec_dir, "C000004"), "not a directory") # matches the pattern but is a file

      expect(committees(fec_dir)).to eq(%w[C00000001 C00000002])
    end
  end

  describe "#efile_contributor_name" do
    it "builds 'Last, First Middle' when all three name parts are present" do
      row = efile_receipt_row(contributor_last_name: "Doe", contributor_first_name: "Jane",
                               contributor_middle_name: "Marie")
      expect(efile_contributor_name(row)).to eq("Doe, Jane Marie")
    end

    it "returns just the single part when only one name part is present" do
      row = efile_receipt_row(contributor_last_name: "Doe", contributor_first_name: "",
                               contributor_middle_name: "")
      expect(efile_contributor_name(row)).to eq("Doe")
    end

    it "omits the middle-name segment cleanly when the middle name is blank" do
      row = efile_receipt_row(contributor_last_name: "Doe", contributor_first_name: "Jane",
                               contributor_middle_name: "")
      expect(efile_contributor_name(row)).to eq("Doe, Jane")
    end
  end

  describe "#matched_group" do
    it "returns the first group (by hash insertion order) whose keyword hits, even when a later group also matches" do
      options = { groups: { "GroupA" => ["foo"], "GroupB" => ["bar"] } }
      expect(matched_group(options, "this haystack has both foo and bar in it")).to eq(%w[GroupA foo])
    end

    it "returns nil when no group's keywords match" do
      options = { groups: { "GroupA" => ["foo"] } }
      expect(matched_group(options, "nothing relevant here")).to be_nil
    end

    it "downcases the keyword before matching (haystack is expected pre-downcased by the caller)" do
      options = { groups: { "GroupA" => ["FOO"] } }
      expect(matched_group(options, "contains foo lowercase")).to eq(%w[GroupA FOO])
    end
  end

  describe "#scan_schedule_a" do
    def scan(committee_dir, cid, groups, cycle: nil)
      matches = []
      scan_schedule_a(committee_dir, cid, { groups: groups, cycle: cycle }, matches)
      matches
    end

    it "counts rows under both DONOR_LABELS values" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Match Individual",
                            line_number_label: "Contributions From Individuals/Persons Other Than Political Committees"),
            schedule_a_row(contributor_name: "Match Committee",
                            line_number_label: "Contributions From Other Political Committees")
          ]
        }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

      expect(matches.map(&:contributor_name)).to contain_exactly("Match Individual", "Match Committee")
    end

    it "excludes rows under any other line_number_label, e.g. transfers from authorized committees" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Match Transfer",
                            line_number_label: "Transfers from authorized committees")
          ]
        }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

      expect(matches).to be_empty
    end

    it "skips memo_code X rows even when they would otherwise match" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_a: [schedule_a_row(contributor_name: "Match Memo", memo_code: "X")] }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

      expect(matches).to be_empty
    end

    it "scopes to an exact two_year_transaction_period when a cycle is given" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [
            schedule_a_row(contributor_name: "Match In Cycle", two_year_transaction_period: "2026"),
            schedule_a_row(contributor_name: "Match Out Of Cycle", two_year_transaction_period: "2024")
          ]
        }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] }, cycle: "2026")

      expect(matches.map(&:contributor_name)).to eq(["Match In Cycle"])
    end

    it "matches keywords against contributor_name and reports the exact CSV line number" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_a: [schedule_a_row(contributor_name: "Acme Oil Partners")] }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Oil" => ["oil"] })

      expect(matches.size).to eq(1)
      expect(matches.first.group).to eq("Oil")
      expect(matches.first.keyword).to eq("oil")
      expect(matches.first.line).to eq(2) # header is line 1, first data row is line 2
    end

    it "matches keywords against contributor_employer" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_a: [schedule_a_row(contributor_employer: "Permian Resources")] }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Oil" => ["permian"] })

      expect(matches.size).to eq(1)
    end

    it "matches keywords against contributor_occupation" do
      fec_dir = fec_dir_with({
        "C00000001" => { schedule_a: [schedule_a_row(contributor_occupation: "Petroleum Geologist")] }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Oil" => ["petroleum"] })

      expect(matches.size).to eq(1)
    end
  end

  describe "#scan_efile_gap" do
    def scan(committee_dir, cid, groups, cycle: nil)
      matches = []
      scan_efile_gap(committee_dir, cid, { groups: groups, cycle: cycle }, matches)
      matches
    end

    it "excludes efile rows on or before schedule_a's own max date and includes rows strictly after it" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contribution_receipt_date: "2026-06-01")],
          efile_receipts: [
            efile_receipt_row(contributor_last_name: "MatchOn", contributor_first_name: "", contributor_middle_name: "",
                               contribution_receipt_date: "2026-06-01", transaction_id: "T1"),
            efile_receipt_row(contributor_last_name: "MatchBefore", contributor_first_name: "", contributor_middle_name: "",
                               contribution_receipt_date: "2026-05-01", transaction_id: "T2"),
            efile_receipt_row(contributor_last_name: "MatchAfter", contributor_first_name: "", contributor_middle_name: "",
                               contribution_receipt_date: "2026-06-02", transaction_id: "T3")
          ]
        }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

      expect(matches.map(&:contributor_name)).to eq(["MatchAfter"])
    end

    it "skips a committee with no schedule_a file at all rather than guessing a ceiling date" do
      fec_dir = fec_dir_with({
        "C00000001" => { efile_receipts: [efile_receipt_row(contributor_last_name: "MatchNoBaseline")] }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

      expect(matches).to be_empty
    end

    describe "dedup pass 1: by transaction_id" do
      it "keeps only the row with the max load_timestamp per shared transaction_id" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_a: [schedule_a_row(contribution_receipt_date: "2020-01-01")],
            efile_receipts: [
              efile_receipt_row(contributor_last_name: "MatchOldRow", contributor_first_name: "", contributor_middle_name: "",
                                 contribution_receipt_amount: "111.00", transaction_id: "SHARED1",
                                 load_timestamp: "2026-01-01T00:00:00Z", contribution_receipt_date: "2026-07-01"),
              efile_receipt_row(contributor_last_name: "MatchNewRow", contributor_first_name: "", contributor_middle_name: "",
                                 contribution_receipt_amount: "222.00", transaction_id: "SHARED1",
                                 load_timestamp: "2026-06-01T00:00:00Z", contribution_receipt_date: "2026-07-01")
            ]
          }
        })

        matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

        expect(matches.map(&:contributor_name)).to eq(["MatchNewRow"])
        expect(matches.first.amount).to eq(BigDecimal("222.00"))
      end

      it "passes rows with an empty transaction_id through ungrouped instead of colliding them" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_a: [schedule_a_row(contribution_receipt_date: "2020-01-01")],
            efile_receipts: [
              efile_receipt_row(contributor_last_name: "MatchNoTxnOne", contributor_first_name: "", contributor_middle_name: "",
                                 transaction_id: "", contribution_receipt_amount: "10.00",
                                 contribution_receipt_date: "2026-07-01", load_timestamp: "2026-07-02T00:00:00Z"),
              efile_receipt_row(contributor_last_name: "MatchNoTxnTwo", contributor_first_name: "", contributor_middle_name: "",
                                 transaction_id: "", contribution_receipt_amount: "20.00",
                                 contribution_receipt_date: "2026-07-01", load_timestamp: "2026-07-02T00:00:00Z")
            ]
          }
        })

        matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

        expect(matches.map(&:contributor_name)).to contain_exactly("MatchNoTxnOne", "MatchNoTxnTwo")
      end
    end

    it "dedup pass 2: collapses an amendment's new transaction_id sharing the same natural key, keeping the max load_timestamp" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contribution_receipt_date: "2020-01-01")],
          efile_receipts: [
            efile_receipt_row(contributor_last_name: "MatchAmend", contributor_employer: "OldEmployer",
                               transaction_id: "TXA", load_timestamp: "2026-01-01T00:00:00Z",
                               contribution_receipt_date: "2026-07-05", contribution_receipt_amount: "150.00"),
            efile_receipt_row(contributor_last_name: "MatchAmend", contributor_employer: "NewEmployer",
                               transaction_id: "TXB", load_timestamp: "2026-08-01T00:00:00Z",
                               contribution_receipt_date: "2026-07-05", contribution_receipt_amount: "150.00")
          ]
        }
      })

      matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

      expect(matches.size).to eq(1)
      expect(matches.first.contributor_employer).to eq("NewEmployer")
    end

    describe "entity_type / line_number restriction" do
      it "counts an IND row on 11AI and a PAC row on 11C, but not an IND on 11C or a PAC on 11AI" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_a: [schedule_a_row(contribution_receipt_date: "2020-01-01")],
            efile_receipts: [
              efile_receipt_row(contributor_last_name: "MatchIndAI", contributor_first_name: "", contributor_middle_name: "",
                                 entity_type: "IND", line_number: "11AI",
                                 transaction_id: "T1", contribution_receipt_amount: "10.00",
                                 contribution_receipt_date: "2026-07-01"),
              efile_receipt_row(contributor_last_name: "MatchPacC", contributor_first_name: "", contributor_middle_name: "",
                                 entity_type: "PAC", line_number: "11C",
                                 transaction_id: "T2", contribution_receipt_amount: "20.00",
                                 contribution_receipt_date: "2026-07-02"),
              efile_receipt_row(contributor_last_name: "MatchIndC", contributor_first_name: "", contributor_middle_name: "",
                                 entity_type: "IND", line_number: "11C",
                                 transaction_id: "T3", contribution_receipt_amount: "30.00",
                                 contribution_receipt_date: "2026-07-03"),
              efile_receipt_row(contributor_last_name: "MatchPacAI", contributor_first_name: "", contributor_middle_name: "",
                                 entity_type: "PAC", line_number: "11AI",
                                 transaction_id: "T4", contribution_receipt_amount: "40.00",
                                 contribution_receipt_date: "2026-07-04")
            ]
          }
        })

        matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] })

        expect(matches.map(&:contributor_name)).to contain_exactly("MatchIndAI", "MatchPacC")
      end
    end

    describe "--cycle approximation by calendar year" do
      it "includes rows dated in the cycle year or cycle - 1, excludes cycle - 2" do
        fec_dir = fec_dir_with({
          "C00000001" => {
            schedule_a: [schedule_a_row(contribution_receipt_date: "2020-01-01")],
            efile_receipts: [
              efile_receipt_row(contributor_last_name: "MatchCycleYear", contributor_first_name: "", contributor_middle_name: "",
                                 transaction_id: "T1", contribution_receipt_date: "2026-06-01"),
              efile_receipt_row(contributor_last_name: "MatchCycleMinusOne", contributor_first_name: "", contributor_middle_name: "",
                                 transaction_id: "T2", contribution_receipt_date: "2025-06-01"),
              efile_receipt_row(contributor_last_name: "MatchCycleMinusTwo", contributor_first_name: "", contributor_middle_name: "",
                                 transaction_id: "T3", contribution_receipt_date: "2024-06-01")
            ]
          }
        })

        matches = scan(File.join(fec_dir, "C00000001"), "C00000001", { "Test" => ["match"] }, cycle: "2026")

        expect(matches.map(&:contributor_name)).to contain_exactly("MatchCycleYear", "MatchCycleMinusOne")
      end
    end
  end

  describe "#render" do
    def sample_match(overrides = {})
      DonorMatch.new({
        group: "Group A", keyword: "match", committee_id: "C00000001", committee_name: "TEST FOR CONGRESS",
        file: "fec/C00000001/schedule_a-2026-01-01T00_00_00Z.csv", line: 2, date: "2026-01-15",
        contributor_name: "Doe, Jane", contributor_employer: "Acme Corp", contributor_occupation: "Engineer",
        contributor_city: "Austin", contributor_state: "TX", amount: BigDecimal("100.00"), is_individual: true,
        transaction_id: "SA_1", source: "schedule_a"
      }.merge(overrides))
    end

    describe "json format" do
      it "groups matches, sums per-group totals as fixed-point decimal strings, and serializes rows" do
        matches = [
          sample_match(group: "Group A", contributor_name: "Donor One", amount: BigDecimal("100.00")),
          sample_match(group: "Group A", contributor_name: "Donor Two", amount: BigDecimal("50.25")),
          sample_match(group: "Group B", contributor_name: "Donor Three", amount: BigDecimal("10.00"))
        ]

        parsed = JSON.parse(render_donor_report(matches, "json"))

        expect(parsed.keys).to contain_exactly("Group A", "Group B")
        expect(parsed["Group A"]["total"]).to eq("150.25")
        expect(parsed["Group A"]["count"]).to eq(2)
        expect(parsed["Group A"]["rows"].map { |r| r["contributor_name"] }).to eq(%w[Donor\ One Donor\ Two])
        # BigDecimal#to_s("F") always emits at least one digit after the point and strips
        # trailing zeros beyond that, so a whole-cents amount like 100.00 renders as "100.0".
        expect(parsed["Group A"]["rows"].map { |r| r["amount"] }).to eq(%w[100.0 50.25])
        expect(parsed["Group B"]["total"]).to eq("10.0")
        expect(parsed["Group B"]["count"]).to eq(1)
      end
    end

    describe "text format" do
      it "starts with the NOTE disclaimer about free-text donor data" do
        output = render_donor_report([sample_match], "text")

        expect(output).to start_with(
          "NOTE: donor names, employers, and occupations below are free text filed by"
        )
      end

      it "prints a per-group row count and dollar total line" do
        matches = [
          sample_match(amount: BigDecimal("100.00")),
          sample_match(amount: BigDecimal("50.00"), contributor_name: "Other Donor")
        ]

        output = render_donor_report(matches, "text")

        expect(output).to include("Group A — 2 row(s), $150.00")
      end

      it "tags only efile-gap sourced rows, and appends an efile-gap subtotal line for the group" do
        matches = [
          sample_match(source: "schedule_a", contributor_name: "Processed Donor"),
          sample_match(source: "efile-gap", contributor_name: "Gap Donor", amount: BigDecimal("75.00"))
        ]

        output = render_donor_report(matches, "text")
        processed_line = output.lines.find { |l| l.include?("Processed Donor") }
        gap_line = output.lines.find { |l| l.include?("Gap Donor") }

        expect(processed_line).not_to include("[efile, not yet in processed export]")
        expect(gap_line).to include("[efile, not yet in processed export]")
        expect(output).to include(
          "(of which 1 row(s), $75.00, from efile data not yet in a processed schedule_a export)"
        )
      end

      it "omits the efile-gap subtotal line entirely when a group has no efile-gap rows" do
        output = render_donor_report([sample_match(source: "schedule_a")], "text")

        expect(output).not_to include("not yet in a processed schedule_a export")
      end
    end
  end

  describe "CLI" do
    it "runs end-to-end against a fixture dir and prints valid, well-shaped JSON on success" do
      fec_dir = fec_dir_with({
        "C00000001" => {
          schedule_a: [schedule_a_row(contributor_name: "Match Donor", contributor_employer: "Oil Co")]
        }
      })

      stdout, stderr, status = Open3.capture3(
        "ruby", script_path, "--fec-dir", fec_dir, "--keywords", "match", "--format", "json"
      )

      expect(status.exitstatus).to eq(0)
      expect(stderr).to eq("")
      parsed = JSON.parse(stdout)
      expect(parsed["Matches"]["count"]).to eq(1)
      expect(parsed["Matches"]["rows"].first["contributor_name"]).to eq("Match Donor")
    end

    it "exits nonzero with an stderr error message when --fec-dir/--group are missing" do
      stdout, stderr, status = Open3.capture3("ruby", script_path)

      expect(status.exitstatus).not_to eq(0)
      expect(stdout).to eq("")
      expect(stderr).to include("Error: --fec-dir and at least one of --group/--keywords are required")
    end
  end
end
