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

**Purpose:** Automatically downloads raw efile data plus Schedule A (receipts) and Schedule B (disbursements) data from the FEC via the OpenFEC API, then discovers linked committees.

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
# Step 1: Download committee data
ruby tooling/fec-api-client.rb \
  --download \
  --committee-id C00719294 \
  --output-dir tx-11/august-pfluger/fec

# Step 2: Find linked committees (those that received transfers/donations)
ruby tooling/fec-api-client.rb \
  --fec-dir tx-11/august-pfluger/fec \
  --list-linked

# Output: List of linked committee IDs + ready-to-copy download commands
# Copy those commands and run them to recursively download the full network

# Step 3 (optional): Verify what's been downloaded
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
| `--with-linked` | Auto-discover and download all linked committees found in Schedule B transfers; recursively downloads the entire committee network |
| `--fec-dir DIR` | Directory to scan for linked committees (manual mode only) |
| `--list-linked` | Discover committees referenced in downloaded filings (manual mode only) |
| `--list-files` | Show what CSVs have been downloaded |
| `--help` | Show all flags |

**Caching:**

Before downloading a committee, the tool searches the repo for existing cached data. If found, it copies the cached directory instead of making API calls. This saves quota and time for committees that appear in multiple candidate directories. Cached data is identified by matching committee ID and the presence of valid FEC files (schedules or efiles).

**Workflow example:**

```bash
# Download principal committee + auto-discover and download all linked committees in one command
ruby tooling/fec-api-client.rb --download --committee-id C00719294 --output-dir tx-11/august-pfluger/fec --principal --with-linked

# The --with-linked flag automatically discovers all committees referenced in Schedule B transfers
# (PACs, party committees, transfer recipients, etc.) and downloads them recursively.
# All committees end up in the same fec/ directory.

# Then feed the full collected FEC directory to analyze-candidate.rb
ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --house-ethics-dir tx-11/august-pfluger/house-ethics --by-cycle
```

**Notes:**

- Downloads include:
  - Raw efile data: `efile-2026-07-15T16-35-03.csv` (comprehensive line-item data from each official filing)
  - Structured schedules: `schedule_a-2026-07-19T14-30-05Z.csv`, `schedule_b-...csv` (parsed transactional data)
- All files saved as uncompressed CSVs for direct file searching and grepping.
- No manual FEC website clicking needed — fully automated API-based download.
- API is rate-limited (HTTP 429). The tool automatically retries with exponential backoff (waits 1s, 2s, 4s, 8s, 16s between retries, up to 5 retries).
- Large committees may take a few minutes; typical committees (50-100k rows) download in 2-3 minutes.
