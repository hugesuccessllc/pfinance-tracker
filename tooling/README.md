# Tooling

This directory contains Ruby scripts for analyzing candidate campaign finance disclosures.

## analyze-candidate.rb

**Purpose:** Analyzes FEC filings and House Ethics disclosures for a candidate, producing donor summaries, spending breakdowns, and optional deep-dive filtered reports.

**Usage:**

```bash
# Basic current-cycle summary
ruby tooling/analyze-candidate.rb \
  --fec-dir tx-11/august-pfluger/fec \
  --house-ethics-dir tx-11/august-pfluger/house-ethics

# Output: Text summary with top donors, disbursements, card breakdown, etc.
```

**Common flags:**

| Flag | Purpose | Example |
|------|---------|---------|
| `--fec-dir DIR` | Path to FEC exports directory | `tx-11/august-pfluger/fec` |
| `--house-ethics-dir DIR` | Path to House Ethics files | `tx-11/august-pfluger/house-ethics` |
| `--format json` | Output as JSON instead of text | `--format json` |
| `--by-cycle` | Group results by 2-year FEC cycle (oldest→newest) | `--by-cycle` |
| `--cycle YYYY` | Scope to a single cycle | `--cycle 2026` |
| `--min-amount N` | Report donors ≥ threshold (in addition to top-N list) | `--min-amount 50000` |
| `--donor-type TYPE` | Filter: `individual` or `committee` | `--donor-type committee` |
| `--top N` | Show top N donors/disbursements | `--top 20` |
| `--help` | Show all flags | |

**Multi-cycle deep dives:**

```bash
# Full career history, all cycles
ruby tooling/analyze-candidate.rb \
  --fec-dir tx-11/august-pfluger/fec \
  --house-ethics-dir tx-11/august-pfluger/house-ethics \
  --by-cycle

# Individual donors >$50k aggregate per cycle
ruby tooling/analyze-candidate.rb \
  --fec-dir tx-11/august-pfluger/fec \
  --by-cycle --donor-type individual --min-amount 50000

# All committee/PAC donors, by cycle
ruby tooling/analyze-candidate.rb \
  --fec-dir tx-11/august-pfluger/fec \
  --by-cycle --donor-type committee
```

**Notes:**

- Read the header comments in `analyze-candidate.rb` before trusting any reported totals — they document data-integrity gotchas (duplicate rows, amendment handling, cycle-matching edge cases, etc.).
- Multi-cycle support requires historical FEC exports. Drop older CSVs into the same `fec/<committee-id>/` directory; the tool reads `two_year_transaction_period` per row to segregate them.
- Before writing new analysis tools for a candidate, check whether `analyze-candidate.rb` can be extended with a new flag instead.

## fec-api-client.rb

**Purpose:** Automatically downloads raw efile data plus Schedule A (receipts) and Schedule B (disbursements) data from the FEC via the OpenFEC API for a committee, plus (optionally) financial totals for that committee's affiliated JFC/leadership PAC.

**Setup:**

Requires an OpenFEC API key (get one free at https://api.open.fec.gov/):

```bash
# Save key to .fec_api_key (gitignored)
echo "your-api-key-here" > .fec_api_key

# OR set environment variable
export FEC_API_KEY="your-api-key-here"
```

**Usage:**

```bash
# Step 1: Download the principal committee's data, plus its affiliated committee's totals
ruby tooling/fec-api-client.rb \
  --download \
  --committee-id C00719294 \
  --output-dir tx-11/august-pfluger/fec \
  --principal --with-affiliated --cycle 2026

# Step 2 (optional): Verify what's been downloaded
ruby tooling/fec-api-client.rb \
  --fec-dir tx-11/august-pfluger/fec \
  --list-files
```

**Flags:**

| Flag | Purpose |
|------|---------|
| `--download` | Download data for a committee via API (or copy if cached locally) |
| `--committee-id ID` | Committee ID to download (e.g., `C00719294`) |
| `--output-dir DIR` | Base directory; committee subdir will be created |
| `-p`, `--principal` | Mark this as the principal (main) candidate committee; creates a `PRINCIPAL` marker file |
| `--with-affiliated` | Look up the principal's `affiliated_committee_name` (a JFC or leadership PAC, self-reported on the committee's Form 1) and resolve it to a committee ID via FEC's committee name search, then fetch that committee's financial **totals only** — not itemized Schedule A/B. See "Affiliated committees" below for why. |
| `--affiliated-committee-id ID` | Skip the name search; fetch totals for this specific committee ID as the affiliated committee (use when the name search is ambiguous, or you already know the ID) |
| `--cycle YYYY` | Scope the download to a single 2-year cycle via the API's `two_year_transaction_period` filter (applies to the affiliated committee's totals too). Dramatically reduces API calls for committees with multi-cycle history — use this for current-cycle-only reports. |
| `--fec-dir DIR` | Directory to inspect (with `--list-files`) |
| `--list-files` | Show what CSVs have been downloaded |
| `--help` | Show all flags |

**Affiliated committees: totals only, by design.**

An earlier version of this tool had a `--with-linked` flag that recursively crawled every committee referenced as a Schedule B transfer recipient — donor PACs, party committees, anything. In practice this pulled in large, unrelated committees (e.g. the NRCC) just because a candidate's JFC wrote them a check, ballooning downloads without adding much insight into *that candidate's* operation. It's been replaced with `--with-affiliated`, which asks a narrower question: "what JFC or leadership PAC does this candidate's own filing say it's affiliated with?" — using the `affiliated_committee_name` field FEC's own data model provides for exactly this relationship, resolved to a committee ID via name search.

Because a JFC's own transaction volume can be as large as (or larger than) the principal committee's, `--with-affiliated` fetches only that committee's `/committee/{id}/totals/` — receipts, disbursements, cash-on-hand per cycle — saved to `fec/<affiliated-id>/totals.json`, with an `AFFILIATED` marker file alongside it (parallel to `PRINCIPAL`). No itemized Schedule A/B rows are downloaded for it. `analyze-candidate.rb` reports these totals in a separate "AFFILIATED COMMITTEES" section rather than folding them into itemized donor/spending analysis. If you want full itemized detail for an affiliated committee, run `--download --committee-id <that-id>` directly instead — that gets you the normal itemized treatment.

**Caching and cycle top-ups:**

Every committee directory tracks which cycles it has via a `.cycles-downloaded` manifest (a cycle year like `2026`, several comma-separated years, or `ALL` for unscoped downloads). Before downloading, the tool checks this manifest and does the cheapest thing that's still correct:

- **Already covered** (same cycle requested again, or full history already present) — skips the download entirely.
- **New cycle, other cycles already present** — fetches only the new cycle and adds it alongside the existing files. For example, if you already have `--cycle 2026` downloaded and later add `--cycle 2024`, both live in the same directory as separate files.
- **Full history requested, only partial cycles cached** — a full download re-fetches every cycle including ones already present, so the tool deletes the superseded partial files first (printing what it removed) rather than leaving overlapping data behind. This matters because `analyze-candidate.rb` concatenates every `schedule_*.csv` file in a directory without deduping across files — two files covering the same cycle would silently double-count transactions.

This also means you can safely start with `--cycle 2026` for a quick current-cycle report, then later re-run without `--cycle` for a full-history deep dive — the tool handles the transition itself.

The tool also searches the rest of the repo for a cached copy of a committee (useful when the same committee appears under multiple candidate directories, e.g. a shared joint fundraising committee). It only reuses a cross-repo cache if that cache's manifest actually covers what you asked for; otherwise it downloads fresh rather than copying something insufficient.

**Workflow example:**

```bash
# Download principal committee (itemized) + affiliated committee (totals only),
# scoped to the current cycle to conserve API quota:
ruby tooling/fec-api-client.rb --download --committee-id C00719294 --output-dir tx-11/august-pfluger/fec --principal --with-affiliated --cycle 2026

# Then feed the full collected FEC directory to analyze-candidate.rb
ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --house-ethics-dir tx-11/august-pfluger/house-ethics --cycle 2026
```

**Progress tracking:**

Downloads are incremental — CSVs are written as pages arrive, so partial results are saved even if the download is interrupted. Track progress via metadata files:

- `schedule_a-TIMESTAMP.csv.meta` — Shows pages fetched, total pages, rows written, status (`in_progress` or `complete`)
- `schedule_b-TIMESTAMP.csv.meta` — Same for disbursements
- `.efile-progress` — Tracks efile filings downloaded (pages fetched, files downloaded, status)
- `.download-progress` — Committee-level marker showing download timestamp and final status

Example `.meta` file:
```
timestamp: 2026-07-19T14:30:15.123456Z
pages_fetched: 206
total_pages: 393
rows_written: 20600
status: in_progress
```

If a download is interrupted by rate limiting, the partial CSV and its `.meta` file remain on disk (useful for inspection), but **re-running the command does not resume that file** — it starts a fresh timestamped CSV from page 1. To avoid burning quota on repeat full downloads:
1. Wait for API quota to reset (rolling 1-hour window), then re-run
2. Use `--cycle YYYY` to scope to one cycle instead of full history — this is usually the real fix, since most quota exhaustion comes from paging through cycles you don't need for a current-cycle report

**Notes:**

- Downloads include:
  - Raw efile data: `efile-2026-07-15T16-35-03.csv` (comprehensive line-item data from each official filing)
  - Structured schedules: `schedule_a-2026-07-19T14-30-05Z.csv`, `schedule_b-...csv` (parsed transactional data)
- All files saved as uncompressed CSVs for direct file searching and grepping.
- No manual FEC website clicking needed — fully automated API-based download.
- API is rate-limited (HTTP 429): 1,000 calls/hour for a personal key (40/hour for `DEMO_KEY`; email apiinfo@fec.gov for a 7,200/hour upgraded key). The tool paces successive page requests (0.5s apart) to avoid tripping short-window burst limits, and retries 429s with exponential backoff (1s, 2s, 4s, 8s, 16s, up to 5 retries) as a fallback. Pacing and backoff both reduce *how often* you hit 429, but the real lever for large committees is `--cycle` — it cuts the number of pages fetched in the first place.
- Large committees may take a few minutes; typical committees (50-100k rows) download in 2-3 minutes. `--with-affiliated` adds only a few quick API calls (committee detail, name search, totals) regardless of how large the affiliated committee's own itemized history is, since no itemized data is fetched for it.
