# Pfinance Tracker

This is todb's Pfinance Tracker, useful for tracking the financial disclosures for candidates for the US House of Representatives. It's a toy for now, mostly to teach myself how robust prompt engineering works. The findings shouldn't be believed without rigorous fact-checking.

Currently, it relies on two major data soruces:

* The FEC
* THe US House Ethics Committee

Each candidate of interest has their disclosures copied here in their respective directories. For example, a candidate for TX-11 named "Pfluger" would end up in `tx-11/august-pfluger`.

This is mostly an experiment in how far I can get with my AI pals. I'll be documenting my process, prompts, and setup as well, so other people can do similar financial spelunking with robot friends.

# License

The code is licensed under the normal [MIT License](https://mit-license.org)

The prose outputs are largely (but not entirely) machine generated. To the extent possible, the prose is licensed under [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)

By submitting a contribution, you grant Huge Success, LLC. a perpetual, worldwide, non-exclusive, irrevocable copyright and patent license to use, modify, distribute, sublicense, and relicense your contribution.

# Process

The below details the process of collecting data.

## Collect FEC Data

FEC data comes in two forms: raw efile dumps and structured transaction schedules. You can collect it manually via the FEC web UI or automatically via the OpenFEC API.

### Automated Way (Recommended)

Use [`/tooling/fec-api-client.rb`](tooling/fec-api-client.rb) to download committee data automatically. This gets you:
- Raw efile CSVs (comprehensive line-item filings)
- Schedule A (receipts/contributions)
- Schedule B (disbursements)
- Linked committee discovery (to find related PACs, transfer recipients, etc.)

**Setup:** Get a free API key at https://api.data.gov/ (takes 30 seconds), then:

```bash
echo "your-api-key-here" > .fec_api_key
```

**Quick start:** Download a committee's current filing data:

```bash
ruby tooling/fec-api-client.rb --download --committee-id C00719294 --output-dir tx-11/august-pfluger/fec --principal
```

The `--principal` flag marks this committee with a `PRINCIPAL` marker file for easy identification.

**Multi-cycle:** To include older cycles, repeat the download for each cycle (the tool handles multiple CSV files in one directory — see [tooling/README.md](tooling/README.md) for details).

**Local caching:** If a committee ID appears in multiple candidate directories, the tool searches your repo for existing cached data and copies it instead of re-downloading, saving API quota.

For full documentation, flags, and linked-committee discovery, see [tooling/README.md](tooling/README.md).

### Manual Way

Manually export from https://www.fec.gov/data/:

* Make a directory to store FEC things. For example, for August Pfluger, running in TX-11, it would be:

`mkdir -p tx-11/august-pfluger/fec/`

* Go to https://www.fec.gov/data/
* Seach your candidate's name, and notice active committees, like so:

<img src="images/fec-search.png" width=300>

* Note the committee number you're interested in (in this case, `C00719294`), and make a directory for it: `mkdir -p tx-11/august-pfluger/fec/C00719294`

* Visit the committee page, eg `https://www.fec.gov/data/committee/C00719294/`, and click "Browse Reciepts", once you've checked you're looking at the right year.

<img src="images/committee-page-receipts.png" width=600>

* Click Export, and wait a moment. By default, you're exporting the processed data. Save it to the directory you just made.

* Flip over to Raw data, and do it again. What's the precise difference between "processed" and "raw?" Got me, may as well grab them both, more data is always better, right?

<img src="images/raw-data-export.png" width=600>

* With your browser's back button, go back, and then select "Browse Disbursements," the next section after Receipts.

<img src="images/browse-disbursements.png" width=600>

* Export in the same way; processed, then raw, and save those. You'll want to routinely clear the "Your Downloads" tab because they'll get confusing after about three:

<img src="images/clear-button.png" width=200>

* Move on to the next committee (some candidates have more than one, as seen below).

<img src="images/several-committees.png" width=300>

* Repeat all the above for each committee. Note each committee's ID and create a matching directory.

# Collect House Ethics Committee Data

## Automated Way

<img src="images/under-construction.gif" width=200>

House Ethics Committee data automation is not yet implemented. Contributions welcome! For now, use the manual method below.

## Manual Way

* Create a directory, `house-ethics` for your candidate or member: `mkdir -p tx-11/august-pfluger/house-ethics`
* Go to https://disclosures-clerk.house.gov/FinancialDisclosure
* Hit Search
* Select Member or Candidate (Member is default)
* Fill in the details.

<img src="images/house-ethics-search.png" width=350>

* Right click on each, "Save Link As" and save them in the `house-ethics` folder.
* Collect each year you're interested in. Note that House races are every two years, so you'll probably want two years' worth of filings.

# Prompts

Now the hard part, the actual data science.

In the old days, we'd use our goop-filled human eyes and read all these boring documents by gaslight.

Then, we got smarter, discovered statistics, then renamed it data science, and built elaborate parsers in R and Python to get through documents like this. But, it still takes forever.

Now, we have access to large language models (LLMs).

The smart way to analyze this stuff is to go through these things would be to leverage our LLM friends to help us write those R and Python parsers to do what we want. This is starting to sound boring agian, though. The [Max Power](https://youtu.be/iVtB7vLRoUo?t=92) way is just ask the LLM to do all the work, then figure out how to prove whatever wild claims it makes. We'll deal with the matter of proof later.

I've got [Visual Studio Code](https://code.visualstudio.com/download) and the [Claude Code for Visual Studio](https://marketplace.visualstudio.com/items?itemName=dliedke.ClaudeCodeExtension) extension, along with a $20/month subscription and a working knowledge of Ruby (my R and Python knowledge is much thinner). Let's go to town.

## Default current cycle summary generation

**Prompt v3** (updated to explicitly scope cycle and require tool-based data filtering)

This prompt is a reusable template for the standard one-cycle executive summary — copy everything from the variable block down to the closing quote, fill in `$CANDIDATE`, `$DISTRICT`, and `$CYCLE`, and hand it to a fresh LLM session. (For multi-cycle or focused deep-dive analyses, see "We Must Go Deeper!" below.)

```
CANDIDATE: `Candidate Name`
DISTRICT: `District Name`
CYCLE: `2026` (or current election cycle)
```

Every `$CANDIDATE` / `$DISTRICT` below is that same substitution. `$CANDIDATE_DIR` is not filled in separately — derive it from $CANDIDATE and $DISTRICT using the convention already shown in "Process" above (lowercased district + kebab-case candidate name, e.g. `TX-11` + `August Pfluger` → `tx-11/august-pfluger`); if a close-but-not-exact match already exists under `tx-*/`, use that directory instead of creating a new one.

**Prompt history (v3):** Updated to explicitly require cycle scoping. Earlier versions (v1–v2) could accidentally include multi-cycle data when only current-cycle analysis was intended. v3 adds `$CYCLE` as a required input variable and mandates use of `ruby tooling/analyze-candidate.rb --cycle $CYCLE` before analysis to ensure all numbers reflect only the specified cycle. This prevents accidental inclusion of old data when the committee directory contains historical filings.

**Before running this analysis:** Download the principal committee's complete FEC data using the Automated Way described in "Collect FEC Data" above. This one-time download gets all available historical data. You'll then scope this prompt to the current cycle only (see below).

**Prompt history:** the pilot run of this prompt (TX-11/August-Pfluger) shipped a summary with a "Correction (post-publication review)" section — it took a second pass, prompted by a human asking pointed questions, to catch a couple of data-integrity bugs after the fact. Both are now fixed in [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) and documented in its header comments, not repeated here — see the note below on why. This prompt (v2) tells the model to read and reuse that tool up front, specifically so a fresh session doesn't rediscover the same bugs before it can trust its own numbers. A "Correction" section in the output is a sign this prompt or the tool needs another pass, not an acceptable steady state.

**Tooling requirements:** Any tooling written to perform this analysis must be written in Ruby, using the version pinned in [`.ruby-version`](.ruby-version). Save all tooling artifacts (scripts, Rakefiles, etc.) to the `/tooling` directory. Gems should be managed normally with Bundler and a `Gemfile`, so the repo remains portable and reproducible for anyone with `rbenv` and `bundler` installed. **Before writing anything new, check whether [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) already exists and covers this candidate's data** (`bundle exec ruby tooling/analyze-candidate.rb --help` shows its interface). It's built to be reused across candidates via `--fec-dir` / `--house-ethics-dir` arguments — extend it in place if a candidate's filings need something it doesn't handle yet, rather than writing a parallel one-off script. **Read that file's header comments in full before trusting or reporting any total** — they hold the specific, tested data-integrity gotchas (duplicate/amended filings, dropped correction rows, lump-sum vendor payments that look unitemized but aren't, and more) as close to the code they explain as possible, so they stay accurate as the tool changes instead of drifting out of sync with a second copy kept here.

**Analyze financial disclosure documents for $CANDIDATE ($DISTRICT) and create an executive summary for the $CYCLE election cycle only.**

**Scope:** This analysis covers **only** transactions dated within the $CYCLE election cycle (filed in $CYCLE). Do not include historical cycles or outdated filings, even if older data exists in the source files. Filter all donors and spending to cycle-year transactions only.

**Run this before starting the analysis:**
```bash
ruby tooling/analyze-candidate.rb \
  --fec-dir $CANDIDATE_DIR/fec \
  --house-ethics-dir $CANDIDATE_DIR/house-ethics \
  --cycle $CYCLE
```

Use the output as your source data. The tool filters transactions to the specified cycle and documents any data-integrity warnings. Read the tool's header comments (in `/tooling/analyze-candidate.rb`) to understand how it handles multi-cycle data and amendments.

**Output:**
- Format: Markdown
- Filename: `$CANDIDATE_DIR/README.md`
- Length: Main analysis should be roughly 1,000-1,500 words. The complete Methodology & AI Transparency section (including the full verbatim prompt) doesn't count against this word limit.
- Title: `$DISTRICT: $CANDIDATE — Financial Disclosure Summary ($CYCLE Cycle)`

**Content sections (in this order):**

1. **Key Donors** — Top 5-10 individual/corporate donors by contribution amount in the $CYCLE cycle. Include amounts and donor affiliation where relevant.

2. **Major Spending** — Top disbursements by category (e.g., staff, consulting, media, events) in the $CYCLE cycle. Highlight any unusual or notable expenditures.

3. **Takeaways** — 3-5 findings that are newsworthy, unexpected, or revealing about the candidate's priorities, funding sources, or spending patterns in the $CYCLE cycle. Examples: unusual donor relationships, spending that contradicts public messaging, geographic patterns, or high-interest items like luxury dining or travel.

4. **Methodology & AI Transparency** — Disclose the LLM model name/version (e.g., Claude 3.5 Sonnet), key configuration settings (temperature, token limits), and the exact prompt used to generate this analysis (i.e. this template with $CANDIDATE/$DISTRICT/$CYCLE filled in). Include the exact tool command you ran: `ruby tooling/analyze-candidate.rb --fec-dir $CANDIDATE_DIR/fec --house-ethics-dir $CANDIDATE_DIR/house-ethics --cycle $CYCLE`. This transparency allows readers to understand how findings were produced, assess potential model limitations or biases, and reproduce the analysis if desired. If applying `analyze-candidate.rb`'s data-integrity gotchas changed a finding versus a naive read of the data, say so briefly here instead of adding a separate correction section — this prompt already expects that check to happen before publication, not after.

**Tone:** Analytical, conversational for a general political audience. Avoid jargon; explain significance where needed.

**Source:** FEC and House Ethics Committee disclosures in the `$CANDIDATE_DIR/` directory, filtered to the $CYCLE cycle."

# We Must Go Deeper!

The "Default current cycle summary generation" section above produces a fixed, one-cycle executive summary — a high-level snapshot of the current filing period's top donors, spending, and takeaways. But a candidate's financial story often spans multiple cycles, and worth investigating are focused cuts: all corporate/PAC donations across their career, individual donors giving above a threshold in each cycle, or how spending priorities have shifted over time.

This section documents how to build such deep-dive analyses, reusing the existing `analyze-candidate.rb` tool to power them rather than writing parallel scripts.

## Output convention

Deep-dive reports live in a new `deep-dives/` subdirectory alongside the existing `README.md`:

```
tx-11/august-pfluger/
├── README.md                          # current-cycle summary (unchanged)
├── fec/
├── house-ethics/
└── deep-dives/
    ├── full-history.md                # multi-cycle career analysis
    ├── corporate-donors.md            # focused: corporate/PAC donations
    └── large-individual-donors.md     # focused: individual donors >$50k per cycle
```

Each deep-dive file follows the same `$CANDIDATE`/`$DISTRICT`/`$CANDIDATE_DIR` substitution convention already established, and the same "Methodology & AI Transparency" format as the main README, with a verbatim prompt appended for reproducibility.

## Collecting multi-cycle data

For full-career or multi-year deep dives, you need FEC data spanning multiple cycles. **The first automated download gets all currently available data** — the OpenFEC API returns complete transaction history for a committee, regardless of cycle.

**Initial setup (one-time):** The first download via `fec-api-client.rb` automatically retrieves all available historical data for a committee:

```bash
ruby tooling/fec-api-client.rb --download --committee-id C00719294 --output-dir tx-11/august-pfluger/fec --principal
```

This populates `tx-11/august-pfluger/fec/C00719294/` with:
- All schedule_a filings (complete transaction history)
- All schedule_b filings (complete transaction history)
- All raw efile submissions (all years)

The `analyze-candidate.rb` tool then reads the `two_year_transaction_period` field on each row to segregate by cycle when you use flags like `--by-cycle` or `--cycle 2026`.

**Updating later:** If new filings appear after your initial download, re-run the download command to the same committee directory — it will fetch fresh data and add it alongside existing files. The caching mechanism won't interfere because you're downloading to the same location.

**For prior, now-terminated committee IDs:**
If your candidate ran under a different committee ID in an earlier cycle (discoverable via the FEC committee page's "Affiliated/Related committees" link), create a new `fec/<old-committee-id>/` directory and download that committee's data separately:

```bash
ruby tooling/fec-api-client.rb --download --committee-id C00OLD123 --output-dir tx-11/august-pfluger/fec
```

This protects against a known naming footgun: the script only recognizes committee directories matching `/\AC\d{6,}\z/` (committee ID, C-prefix). If you accidentally name a directory after the FEC candidate ID (H-prefix, e.g. `H6TX11112`) instead of the committee ID, the tool silently finds zero committees and reports all-zero totals with no warning — so use the committee ID consistently.

## New tool flags for deep dives

Run `bundle exec ruby tooling/analyze-candidate.rb --help` to see the full reference, but the key additions are:

| Flag | Purpose | Example |
|------|---------|---------|
| `--by-cycle` | Group donors and disbursements by FEC 2-year cycle, newest-first, instead of one combined total. Surfaces cycle-integrity warnings if any rows have mismatched `two_year_transaction_period` and `fec_election_year` fields. | `--by-cycle` |
| `--cycle YYYY` | Scope the entire report (donors, disbursements, card breakdown) to a single cycle. Overrides `--by-cycle` if both are given. | `--cycle 2026` |
| `--min-amount N` | In addition to the normal `--top N` table, report *every* donor (subject to any active `--cycle` or `--donor-type` filter) whose aggregate per-donor total is ≥ N. | `--min-amount 50000` |
| `--donor-type TYPE` | Restrict to `individual` or `committee` donors (using the FEC's `is_individual` field). Note: there is no structured "corporate" field in this data — narrowing to `committee` is the mechanical step; identifying which committees are corporate-PAC-affiliated requires manual inspection of names. | `--donor-type individual` |

## Example deep-dive use cases

**Full career history:** Show all donors and spending across every cycle you've collected:
```bash
bundle exec ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --house-ethics-dir tx-11/august-pfluger/house-ethics --by-cycle
```

**Individual donors >$50k aggregate per cycle:**
```bash
bundle exec ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --by-cycle --donor-type individual --min-amount 50000
```

**All committee/PAC donors (corporate, party, leadership PAC, etc.):**
```bash
bundle exec ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --by-cycle --donor-type committee
```

**Single-cycle deep dive (e.g. 2024-2026):**
```bash
bundle exec ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026
```

## Deep-dive prompt template

Like "Default current cycle summary generation" above, this is a reusable template for a deep-dive analysis. Fill in the bracketed placeholders and hand the prompt to a fresh LLM session:

```
CANDIDATE: `Candidate Name`
DISTRICT: `District Name`
TOPIC: `Full Career History` or `Corporate & PAC Donors` or `Large Individual Donors (>$50k/cycle)` — whatever this dive investigates.
TOOL_FLAGS: The `--by-cycle`, `--cycle`, `--min-amount`, and/or `--donor-type` flags to run the analysis with.
```

**Analyze financial disclosure documents for $CANDIDATE ($DISTRICT) and create a deep-dive report on $TOPIC.**

**Output:**
- Format: Markdown
- Filename: `$CANDIDATE_DIR/deep-dives/$TOPIC.md` (use a kebab-case slug of the topic in place of `$TOPIC`, e.g. `full-history.md`, `corporate-donors.md`, `large-individual-donors.md`)
- Title: `$DISTRICT: $CANDIDATE — $TOPIC`
- Structure: Adapt the "Key Donors," "Major Spending," and "Takeaways" sections to fit your topic. For a multi-cycle career deep dive, you might instead have per-cycle subsections, trend analysis, or shift analysis. For a donor-type focus like "all corporate/PAC donors," your structure might emphasize industry patterns, donor relationships, or PAC-to-candidate flows rather than top-10 lists.
- Methodology & AI Transparency section: **Include the verbatim tool command** you used to generate this report (e.g. `bundle exec ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --by-cycle --donor-type committee`), so readers can reproduce the analysis. Reference the updated header comments in `/tooling/analyze-candidate.rb` regarding cycle integrity and multi-cycle data handling, distinct from the current-cycle summary prompt.

**Tone:** Same as the main README — analytical, conversational for a general political audience.

**Source:** All data from FEC and House Ethics Committee disclosures in the `$CANDIDATE_DIR/` directory. Before writing prose, run the tool's output through the same data-integrity review you would for a summary: **read `/tooling/analyze-candidate.rb`'s header comments in full** — they document cycle-matching gotchas, the multi-committee/multi-cycle data model, and why cycle-integrity warnings exist. Spot-check any surprising findings against the source CSVs before publication."
