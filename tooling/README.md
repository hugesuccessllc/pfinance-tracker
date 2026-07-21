# Tooling

This directory contains Ruby scripts for analyzing candidate campaign finance disclosures.

**Run every script here as plain `ruby tooling/<script>.rb ...` from the repo root — never `bundle exec ruby tooling/<script>.rb`.** All three scripts (`analyze-candidate.rb`, `fec-api-client.rb`, `vendor-keyword-scan.rb`) share dependencies pinned in `tooling/Gemfile` (`pdf-reader`, `csv`, `bigdecimal`), not the repo-root `Gemfile`, and each one pins its own `ENV["BUNDLE_GEMFILE"]` to `tooling/Gemfile` at the top of the file so plain `ruby` resolves gems correctly no matter your working directory — no `bundle exec` or manual `BUNDLE_GEMFILE=` prefix needed. Running any of them under `bundle exec` from the repo root sets `BUNDLE_GEMFILE` to the root `Gemfile` *before* the script's own `||=` gets a chance to act, so bundler resolves against the wrong Gemfile: `analyze-candidate.rb` hard-fails with `cannot load such file -- pdf-reader` (it's the only one that needs a gem the root Gemfile doesn't have); `fec-api-client.rb` and `vendor-keyword-scan.rb` don't hard-fail today since `csv`/`bigdecimal` still resolve as system default gems, but they'd hit the same failure the moment either script's dependencies changed, and they already emit Ruby 3.4 deprecation warnings under `bundle exec` that plain `ruby` doesn't. If you ever do need `bundle exec` for some other reason, prefix it explicitly instead: `BUNDLE_GEMFILE=tooling/Gemfile bundle exec ruby tooling/<script>.rb ...`.

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

- Run as plain `ruby` — see the repo-wide note at the top of this file for why `bundle exec` breaks this script specifically (it's the one that hard-fails without the fix, since it needs `pdf-reader`).
- Read the header comments in `analyze-candidate.rb` before trusting any reported totals — they document data-integrity gotchas (duplicate rows, amendment handling, cycle-matching edge cases, etc.).
- Multi-cycle support requires historical FEC exports. Drop older CSVs into the same `fec/<committee-id>/` directory; the tool reads `two_year_transaction_period` per row to segregate them.
- Before writing new analysis tools for a candidate, check whether `analyze-candidate.rb` can be extended with a new flag instead.

## vendor-keyword-scan.rb

**Purpose:** Line-referenced keyword search over a candidate's Schedule B (disbursements) data. Where `analyze-candidate.rb` answers "who got paid the most, in what category," this tool answers a narrower question — "show me every disbursement row whose vendor name or description matches one of these keywords, with an exact file and line number for each" — for building a themed report (dining, lodging, gifts, a specific vendor) where you need to cite a receipt, not just a total. It does not editorialize: it prints matched rows and per-group subtotals; grouping keywords into categories and writing prose about what a pattern means is the caller's job.

**Usage:**

```bash
ruby tooling/vendor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec \
  --group "Fine Dining=capital grille,del frisco,oceanaire,tosca" \
  --group "Lodging=hilton,marriott,ritz,st. regis,four seasons"

ruby tooling/vendor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec \
  --keywords "steakhouse,chophouse" --format json
```

**Flags:**

| Flag | Purpose |
|------|---------|
| `--fec-dir DIR` | Candidate's `fec/` directory |
| `--group "Name=kw1,kw2,..."` | Named keyword group (repeatable); matches are case-insensitive substrings against `recipient_name`, `disbursement_description`, and `memo_text` |
| `--keywords LIST` | Shorthand for a single unnamed group ("Matches") |
| `--cycle YYYY` | Scope to one `two_year_transaction_period` |
| `--include-efile-gap` | Also scan raw `efile-*.csv` rows dated after `schedule_b`'s own latest date — see "The efile gap" below |
| `--format json` | JSON instead of text |
| `--out FILE` | Write to a file instead of stdout |

**Line numbers:** matches are reported with the exact physical line number in the source CSV (via Ruby CSV's `lineno`, which correctly accounts for multi-line quoted fields, not just logical row index) — the line a human lands on opening the file in an editor or running `sed -n '<line>p' <file>`.

**The efile gap.** fec.gov's `schedule_b-*.csv` is a "processed" export that can lag a campaign's actual raw filings by months — observed on Pfluger's principal committee and JFC, where `schedule_b` stopped three months before the raw `efile-*.csv` did. `--include-efile-gap` does **not** blindly merge the two (spot-checking found `efile` and `schedule_b` `transaction_id` values don't reliably match for the same transaction, so naive dedup isn't safe — see the double-count warning in the script's header). Instead, per committee, it finds `schedule_b`'s own latest `disbursement_date` and scans only the disbursement-shaped efile rows dated strictly after that — a window `schedule_b` provably has zero rows in. Matches sourced this way are tagged `[efile, not yet in processed export]` (or `"source": "efile-gap"` in JSON).

**Caveats:** substring matching both over- and under-catches — spot-check matches before publishing a total, and see the script's header comments for the full list of gotchas (memo/card sub-item accounting, negative-amount corrections, the efile-gap mechanics).

## fec-api-client.rb

**Status: experimental.** A single working session on this tool turned up three non-trivial correctness bugs: silent pagination duplication (re-fetched the same 100 rows repeatedly instead of paging, which inflated a real $2,500 contribution into an apparent $402,500 one), ~5x file bloat from duplicated embedded metadata, and a request that could hang indefinitely despite configured timeouts. All three are fixed and verified against the live API, but that track record means this tool hasn't yet earned default trust — see the main [README.md](../README.md) for why manual export is the current recommended starting point. If you do use this tool, spot-check its output (e.g. confirm unique `transaction_id` count matches row count) before trusting any total downstream.

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
ruby tooling/fec-api-client.rb --fec-dir tx-11/august-pfluger/fec
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
| `--fec-dir DIR` | Directory to inspect — lists what CSVs have been downloaded |
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

If a download is interrupted, the partial CSV and its `.meta` file remain on disk (useful for inspection), but **re-running the command does not resume that file** — it starts over from the beginning into a fresh timestamped CSV (schedule_a/schedule_b use cursor-based pagination internally, not page numbers, but a restart still means refetching from the first row). To avoid burning quota on repeat full downloads:
1. Wait for API quota to reset (rolling 1-hour window), then re-run
2. Use `--cycle YYYY` to scope to one cycle instead of full history — this is usually the real fix, since most quota exhaustion comes from paging through cycles you don't need for a current-cycle report

**Notes:**

- Downloads include:
  - Raw efile data: `efile-2026-07-15T16-35-03.csv` (comprehensive line-item data from each official filing)
  - Structured schedules: `schedule_a-2026-07-19T14-30-05Z.csv`, `schedule_b-...csv` (parsed transactional data)
- All files saved as uncompressed CSVs for direct file searching and grepping.
- No manual FEC website clicking needed — fully automated API-based download.
- API is rate-limited (HTTP 429): 1,000 calls/hour for a personal key (40/hour for `DEMO_KEY`; email apiinfo@fec.gov for a 7,200/hour upgraded key). The tool paces successive page requests (0.5s apart) to avoid tripping short-window burst limits, and retries with exponential backoff (1s, 2s, 4s, 8s, 16s, up to 5 retries) on 429s, on transient 502/503/504 gateway errors, and on a request that hangs past a hard 90-second wall-clock timeout (a backstop added after observing a request stay wedged for 18+ minutes despite Net::HTTP's own configured timeouts never firing). Pacing and backoff both reduce *how often* you hit these, but the real lever for large committees is `--cycle` — it cuts the number of pages fetched in the first place.
- Large committees may take a few minutes; typical committees (50-100k rows) download in 2-3 minutes. `--with-affiliated` adds only a few quick API calls (committee detail, name search, totals) regardless of how large the affiliated committee's own itemized history is, since no itemized data is fetched for it.
