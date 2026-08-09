# frozen_string_literal: true

require_relative "spec_helper"
require_relative "../fec-api-client"

# Characterization/unit tests for FecApiClient against its CURRENT behavior — no
# refactoring of tooling/fec-api-client.rb happens here. Every filesystem-touching spec
# works inside a Dir.mktmpdir, and every HTTP call is stubbed via WebMock (real network
# is blocked globally by spec_helper's WebMock.disable_net_connect!).
RSpec.describe FecApiClient do
  let(:api_key) { "test-api-key" }

  # Builds a real client without ever touching the repo's actual .fec_api_key file:
  # ENV["FEC_API_KEY"] is set only for the instant of construction (load_api_key reads
  # it once, in #initialize, and stores it in @api_key), then restored immediately —
  # so this can't leak into, or be affected by, the dedicated load_api_key context below.
  let(:client) do
    previous = ENV["FEC_API_KEY"]
    ENV["FEC_API_KEY"] = api_key
    FecApiClient.new
  ensure
    ENV["FEC_API_KEY"] = previous
  end

  def gzip_string(str)
    io = StringIO.new
    gz = Zlib::GzipWriter.new(io)
    gz.write(str)
    gz.close
    io.string
  end

  describe "#initialize / load_api_key precedence" do
    around(:each) do |example|
      original = ENV["FEC_API_KEY"]
      ENV.delete("FEC_API_KEY")
      example.run
      if original
        ENV["FEC_API_KEY"] = original
      else
        ENV.delete("FEC_API_KEY")
      end
    end

    it "reads the key from ENV when set, without consulting the key file" do
      ENV["FEC_API_KEY"] = "env-key"
      instance = FecApiClient.new(api_key_file: "/nonexistent/path/.fec_api_key")
      expect(instance.instance_variable_get(:@api_key)).to eq("env-key")
    end

    it "prefers ENV over the key file when both are present" do
      Dir.mktmpdir do |dir|
        key_file = File.join(dir, ".fec_api_key")
        File.write(key_file, "file-key")
        ENV["FEC_API_KEY"] = "env-key"

        instance = FecApiClient.new(api_key_file: key_file)
        expect(instance.instance_variable_get(:@api_key)).to eq("env-key")
      end
    end

    it "falls back to the key file, stripped of whitespace, when ENV is unset" do
      Dir.mktmpdir do |dir|
        key_file = File.join(dir, ".fec_api_key")
        File.write(key_file, "file-key\n")

        instance = FecApiClient.new(api_key_file: key_file)
        expect(instance.instance_variable_get(:@api_key)).to eq("file-key")
      end
    end

    it "aborts when neither ENV nor a key file are present" do
      Dir.mktmpdir do |dir|
        missing_file = File.join(dir, ".fec_api_key")
        expect {
          capture_stderr { FecApiClient.new(api_key_file: missing_file) }
        }.to raise_error(SystemExit)
      end
    end
  end

  describe "#validate_committee_id! (private)" do
    it "accepts a well-formed committee ID" do
      expect { client.send(:validate_committee_id!, "C00719294") }.not_to raise_error
    end

    it "accepts the minimum 6-digit shape" do
      expect { client.send(:validate_committee_id!, "C000000") }.not_to raise_error
    end

    it "aborts on a path-traversal-shaped string" do
      expect {
        capture_stderr { client.send(:validate_committee_id!, "../../etc") }
      }.to raise_error(SystemExit)
    end

    it "aborts on an empty string" do
      expect {
        capture_stderr { client.send(:validate_committee_id!, "") }
      }.to raise_error(SystemExit)
    end

    it "aborts on a lowercase-prefixed ID" do
      expect {
        capture_stderr { client.send(:validate_committee_id!, "c00719294") }
      }.to raise_error(SystemExit)
    end

    it "aborts on too few digits" do
      expect {
        capture_stderr { client.send(:validate_committee_id!, "C12345") }
      }.to raise_error(SystemExit)
    end
  end

  describe "#neutralize_csv_cell (private)" do
    { "=" => "=cmd|'/c calc'!A1", "+" => "+1+1", "-" => "-2+3", "@" => "@SUM(1+1)",
      "\t" => "\tSMITH", "\r" => "\rSMITH" }.each do |char, value|
      it "prefixes a #{char.inspect}-leading value in a non-safe field with a straight quote" do
        result = client.send(:neutralize_csv_cell, "contributor_name", value)
        expect(result).to eq("'#{value}")
      end
    end

    it "passes a CSV_SAFE_FIELDS header through unchanged even when formula-shaped" do
      result = client.send(:neutralize_csv_cell, "transaction_id", "=SUM(1+1)")
      expect(result).to eq("=SUM(1+1)")
    end

    it "passes contribution_receipt_amount through unchanged even when it starts with -" do
      result = client.send(:neutralize_csv_cell, "contribution_receipt_amount", "-100.00")
      expect(result).to eq("-100.00")
    end

    it "leaves a normal value unchanged" do
      result = client.send(:neutralize_csv_cell, "contributor_name", "Jane Doe")
      expect(result).to eq("Jane Doe")
    end

    it "leaves a nil value unchanged" do
      result = client.send(:neutralize_csv_cell, "memo_text", nil)
      expect(result).to be_nil
    end

    it "leaves an empty string unchanged" do
      result = client.send(:neutralize_csv_cell, "memo_text", "")
      expect(result).to eq("")
    end
  end

  describe "#fetch_committee_detail" do
    let(:committee_id) { "C00719294" }

    it "requests the committee detail endpoint and returns the first result" do
      stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/")
        .with(query: hash_including("api_key" => api_key))
        .to_return(
          status: 200,
          body: { "results" => [{ "committee_id" => committee_id, "name" => "TEST FOR CONGRESS" }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      result = client.fetch_committee_detail(committee_id)
      expect(result).to eq({ "committee_id" => committee_id, "name" => "TEST FOR CONGRESS" })
    end

    it "returns nil when results is empty" do
      stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/")
        .with(query: hash_including("api_key" => api_key))
        .to_return(status: 200, body: { "results" => [] }.to_json, headers: { "Content-Type" => "application/json" })

      expect(client.fetch_committee_detail(committee_id)).to be_nil
    end
  end

  describe "#search_committees_by_name" do
    it "builds the q/api_key/per_page query and returns results" do
      stub_request(:get, "#{FecApiClient::BASE_URL}/committees/")
        .with(query: hash_including("q" => "PFLUGER VICTORY FUND", "api_key" => api_key, "per_page" => "20"))
        .to_return(
          status: 200,
          body: { "results" => [
            { "committee_id" => "C00111111", "name" => "PFLUGER VICTORY FUND" },
            { "committee_id" => "C00719294", "name" => "SELF" }
          ] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      results = client.search_committees_by_name("PFLUGER VICTORY FUND", exclude: "C00719294")
      expect(results).to eq([{ "committee_id" => "C00111111", "name" => "PFLUGER VICTORY FUND" }])
    end

    it "returns an empty array (not nil) when there are no results" do
      stub_request(:get, "#{FecApiClient::BASE_URL}/committees/")
        .with(query: hash_including("q" => "NOBODY HOME"))
        .to_return(status: 200, body: { "results" => [] }.to_json, headers: { "Content-Type" => "application/json" })

      expect(client.search_committees_by_name("NOBODY HOME")).to eq([])
    end
  end

  describe "#fetch_url (private) retry behavior" do
    let(:url) { "#{FecApiClient::BASE_URL}/some/path?api_key=#{api_key}" }

    it "retries once on HTTP 429 and returns the eventual 200 body, sleeping for the backoff" do
      stub_request(:get, url).to_return(
        { status: 429 },
        { status: 200, body: '{"results":[]}', headers: { "Content-Type" => "application/json" } }
      )
      allow(client).to receive(:sleep)

      result = nil
      output = capture_stdout { result = client.send(:fetch_url, url) }

      expect(result).to eq({ "results" => [] })
      expect(output).to include("Rate limited")
      expect(client).to have_received(:sleep).with(1)
      expect(WebMock).to have_requested(:get, url).times(2)
    end

    it "aborts after exceeding max_retries on repeated HTTP 502s" do
      stub_request(:get, url).to_return({ status: 502 }, { status: 502 })
      allow(client).to receive(:sleep)

      expect {
        capture_stdout { capture_stderr { client.send(:fetch_url, url, max_retries: 1) } }
      }.to raise_error(SystemExit)

      expect(client).to have_received(:sleep).once.with(1)
      expect(WebMock).to have_requested(:get, url).times(2)
    end

    it "transparently gzip-decodes a gzip content-encoded response body" do
      payload = { "results" => ["ok"] }
      stub_request(:get, url).to_return(
        status: 200,
        body: gzip_string(payload.to_json),
        headers: { "Content-Type" => "application/json", "content-encoding" => "gzip" }
      )

      expect(client.send(:fetch_url, url)).to eq(payload)
    end
  end

  describe "#discover_affiliated_committee" do
    let(:committee_id) { "C00719294" }

    def stub_detail(name:)
      stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/")
        .with(query: hash_including("api_key" => api_key))
        .to_return(
          status: 200,
          body: { "results" => [{ "committee_id" => committee_id, "affiliated_committee_name" => name }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    def stub_search(q:, results:)
      stub_request(:get, "#{FecApiClient::BASE_URL}/committees/")
        .with(query: hash_including("q" => q))
        .to_return(status: 200, body: { "results" => results }.to_json, headers: { "Content-Type" => "application/json" })
    end

    it "returns nil and says so when the committee has no affiliated_committee_name on file" do
      stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/")
        .with(query: hash_including("api_key" => api_key))
        .to_return(status: 200, body: { "results" => [{ "committee_id" => committee_id }] }.to_json,
                    headers: { "Content-Type" => "application/json" })

      result = nil
      output = capture_stdout { result = client.discover_affiliated_committee(committee_id) }

      expect(result).to be_nil
      expect(output).to include("no affiliated_committee_name on file")
    end

    it "retries with the last word dropped when the full-name search draws a blank, and matches on retry" do
      stub_detail(name: "PFLUGER VICTORY FUND")
      stub_search(q: "PFLUGER VICTORY FUND", results: [])
      stub_search(q: "PFLUGER VICTORY", results: [{ "committee_id" => "C00099999", "name" => "PFLUGER VICTORY COMMITTEE" }])

      result = nil
      output = capture_stdout { result = client.discover_affiliated_committee(committee_id) }

      expect(result).to eq({ "committee_id" => "C00099999", "name" => "PFLUGER VICTORY COMMITTEE" })
      expect(output).to include("No match for the full name")
      expect(WebMock).to have_requested(:get, "#{FecApiClient::BASE_URL}/committees/")
        .with(query: hash_including("q" => "PFLUGER VICTORY FUND"))
      expect(WebMock).to have_requested(:get, "#{FecApiClient::BASE_URL}/committees/")
        .with(query: hash_including("q" => "PFLUGER VICTORY"))
    end

    it "returns the single match when the search returns exactly one result" do
      stub_detail(name: "SOME LEADERSHIP PAC")
      stub_search(q: "SOME LEADERSHIP PAC", results: [{ "committee_id" => "C00055555", "name" => "SOME LEADERSHIP PAC" }])

      result = nil
      capture_stdout { result = client.discover_affiliated_committee(committee_id) }
      expect(result).to eq({ "committee_id" => "C00055555", "name" => "SOME LEADERSHIP PAC" })
    end

    it "returns nil and lists candidates when multiple matches have no exact case-insensitive match" do
      stub_detail(name: "PFLUGER VICTORY FUND")
      stub_search(q: "PFLUGER VICTORY FUND", results: [
        { "committee_id" => "C00011111", "name" => "PFLUGER VICTORY COMMITTEE", "state" => "TX", "designation_full" => "Joint fundraising committee" },
        { "committee_id" => "C00022222", "name" => "PFLUGER LEADERSHIP FUND", "state" => "TX", "designation_full" => "Leadership PAC" }
      ])

      result = nil
      output = capture_stdout { result = client.discover_affiliated_committee(committee_id) }

      expect(result).to be_nil
      expect(output).to include("matched 2 committees")
      expect(output).to include("C00011111")
      expect(output).to include("C00022222")
    end

    it "picks the exact case-insensitive name match out of several candidates" do
      stub_detail(name: "PFLUGER VICTORY FUND")
      stub_search(q: "PFLUGER VICTORY FUND", results: [
        { "committee_id" => "C00033333", "name" => "pfluger victory fund" },
        { "committee_id" => "C00044444", "name" => "PFLUGER VICTORY FUND PAC" }
      ])

      result = nil
      capture_stdout { result = client.discover_affiliated_committee(committee_id) }
      expect(result).to eq({ "committee_id" => "C00033333", "name" => "pfluger victory fund" })
    end
  end

  describe "#read_cycles_manifest / #write_cycles_manifest / #manifest_covers?" do
    it "round-trips a single written cycle" do
      Dir.mktmpdir do |dir|
        client.write_cycles_manifest(dir, Set[2026])
        manifest = client.read_cycles_manifest(dir)

        expect(manifest).to eq(Set[2026])
        expect(client.manifest_covers?(manifest, 2026)).to eq(true)
        expect(client.manifest_covers?(manifest, 2024)).to eq(false)
      end
    end

    it "treats a written :all manifest as covering any requested cycle" do
      Dir.mktmpdir do |dir|
        client.write_cycles_manifest(dir, :all)
        manifest = client.read_cycles_manifest(dir)

        expect(manifest).to eq(:all)
        expect(client.manifest_covers?(manifest, 2024)).to eq(true)
        expect(client.manifest_covers?(manifest, 2026)).to eq(true)
        expect(client.manifest_covers?(manifest, nil)).to eq(true)
      end
    end

    it "round-trips multiple combined cycles" do
      Dir.mktmpdir do |dir|
        client.write_cycles_manifest(dir, Set[2022, 2024])
        manifest = client.read_cycles_manifest(dir)

        expect(manifest).to eq(Set[2022, 2024])
        expect(client.manifest_covers?(manifest, 2022)).to eq(true)
        expect(client.manifest_covers?(manifest, 2024)).to eq(true)
        expect(client.manifest_covers?(manifest, 2026)).to eq(false)
      end
    end

    it "returns nil from read_cycles_manifest when no manifest file exists" do
      Dir.mktmpdir do |dir|
        expect(client.read_cycles_manifest(dir)).to be_nil
      end
    end

    it "a nil manifest never covers a specific requested cycle" do
      expect(client.manifest_covers?(nil, 2026)).to eq(false)
    end

    it "a nil requested cycle (full history) is only covered by :all, not a partial Set" do
      expect(client.manifest_covers?(Set[2026], nil)).to eq(false)
    end
  end

  describe "#list_downloaded_files" do
    it "lists each committee directory's files" do
      Dir.mktmpdir do |dir|
        committee_dir = File.join(dir, "C00719294")
        FileUtils.mkdir_p(committee_dir)
        File.write(File.join(committee_dir, "schedule_a-2026-01-01T00_00_00Z.csv"), "a,b\n1,2\n")
        File.write(File.join(committee_dir, "totals.json"), "{}")

        output = capture_stdout { client.list_downloaded_files(dir) }

        expect(output).to include("C00719294")
        expect(output).to include("schedule_a-2026-01-01T00_00_00Z.csv")
        expect(output).to include("totals.json")
        expect(output).to include("2 file(s)")
      end
    end

    it "does not raise and says so when no committee directories are present" do
      Dir.mktmpdir do |dir|
        output = nil
        expect { output = capture_stdout { client.list_downloaded_files(dir) } }.not_to raise_error
        expect(output).to include("No committee directories found.")
      end
    end
  end

  describe "#download_committee_totals" do
    let(:committee_id) { "C00099999" }

    def stub_detail_and_totals(cycle_query: nil, totals_results: [{ "cycle" => 2026, "receipts" => 1000 }])
      stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/")
        .with(query: hash_including("api_key" => api_key))
        .to_return(
          status: 200,
          body: { "results" => [{
            "committee_id" => committee_id,
            "name" => "TEST JFC",
            "designation_full" => "Joint fundraising committee",
            "committee_type_full" => "Joint fundraising committee"
          }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      totals_query = { "api_key" => api_key, "per_page" => "100" }
      totals_query["cycle"] = cycle_query.to_s if cycle_query

      stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/totals/")
        .with(query: hash_including(totals_query))
        .to_return(status: 200, body: { "results" => totals_results }.to_json, headers: { "Content-Type" => "application/json" })
    end

    it "writes totals.json with the expected payload and an AFFILIATED marker" do
      Dir.mktmpdir do |dir|
        stub_detail_and_totals

        capture_stdout { client.download_committee_totals(committee_id, dir) }

        totals_path = File.join(dir, committee_id, "totals.json")
        expect(File.exist?(totals_path)).to eq(true)

        payload = JSON.parse(File.read(totals_path))
        expect(payload).to eq(
          "committee_id" => committee_id,
          "name" => "TEST JFC",
          "designation_full" => "Joint fundraising committee",
          "committee_type_full" => "Joint fundraising committee",
          "totals_by_cycle" => [{ "cycle" => 2026, "receipts" => 1000 }]
        )

        expect(File.exist?(File.join(dir, committee_id, "AFFILIATED"))).to eq(true)
      end
    end

    it "includes a cycle= param in the totals request when a cycle is given" do
      Dir.mktmpdir do |dir|
        stub_detail_and_totals(cycle_query: 2026)

        capture_stdout { client.download_committee_totals(committee_id, dir, cycle: 2026) }

        expect(WebMock).to have_requested(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/totals/")
          .with(query: hash_including("cycle" => "2026"))
      end
    end

    it "still writes a payload (with nil name fields) when the committee detail has no results" do
      Dir.mktmpdir do |dir|
        stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/")
          .with(query: hash_including("api_key" => api_key))
          .to_return(status: 200, body: { "results" => [] }.to_json, headers: { "Content-Type" => "application/json" })
        stub_request(:get, "#{FecApiClient::BASE_URL}/committee/#{committee_id}/totals/")
          .with(query: hash_including("api_key" => api_key, "per_page" => "100"))
          .to_return(status: 200, body: { "results" => [] }.to_json, headers: { "Content-Type" => "application/json" })

        capture_stdout { client.download_committee_totals(committee_id, dir) }

        payload = JSON.parse(File.read(File.join(dir, committee_id, "totals.json")))
        expect(payload["name"]).to be_nil
        expect(payload["totals_by_cycle"]).to eq([])
      end
    end

    it "aborts on an invalid committee ID without making any HTTP request" do
      Dir.mktmpdir do |dir|
        expect {
          capture_stderr { client.download_committee_totals("not-an-id", dir) }
        }.to raise_error(SystemExit)

        expect(WebMock).not_to have_requested(:get, /open\.fec\.gov/)
      end
    end
  end
end
