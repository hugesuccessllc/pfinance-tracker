# TX-11: August Pfluger — Financial Disclosure Summary (2024 Cycle)

August Pfluger's 2024 race was, per `historical-election-results.md`, "(mostly) unopposed": no Democrat filed against him, and his only ballot opponent was Libertarian Wacey Alpha Cody, whom he beat 211,975 to 67,637. That result makes the money in this report worth reading with a specific question in mind — what does a three-committee, multi-million-dollar operation spend on when the outcome was never in doubt? As with the 2026 cycle, the money doesn't live in one place: the principal campaign committee (**August Pfluger for Congress**, C00719294), the leadership PAC (**Raptor PAC**, C00749481), and the joint fundraising committee (**Pfluger Victory Fund**, C00753913) each play a distinct role, and all three are already collected locally.

Combined itemized donor receipts across the three committees total **$4,991,244** for the 2024 cycle — about 73% from individuals ($3.65M) and 27% from PACs and other committees ($1.34M). Combined disbursements were **$6,786,973**, of which **$2,324,400** (34%) is inter-committee transfers rather than outside spending.

## Key Donors

| Donor | Amount | Affiliation |
|---|---|---|
| Syed J. Anwar (Midland, TX) | **$150,000** | President/CEO, Midland Energy — Permian Basin oil |
| John Mabee (Midland, TX) | $60,000 | Manager, Mabee Ranch |
| Gayla Mabee (Midland, TX) | $60,000 | Homemaker |
| Cool Master Pro (Tampa, FL) | $30,000 | Corporate entity donor |
| Donald L. Evans (Midland, TX) | $26,500 | President, The Don Evans Group |
| WFF Investments LLC (Columbus, OH) | $21,600 | Corporate entity donor |
| Valero Political Action Committee | $20,000 | Split $10,000/$10,000 across campaign and Raptor PAC |
| KochPAC — Koch Industries | $20,000 | Split across all three committees |
| National Association of Realtors PAC | $20,000 | Split $10,000/$10,000 |
| National Cattlemen's Beef Association PAC | $20,000 | Split $10,000/$10,000 |

All ten of these gave through the Pfluger Victory Fund (JFC) or a PAC-to-PAC split, not the campaign committee alone — the same JFC-centric fundraising pattern documented in the 2026-cycle report. Anwar's $150,000 alone is roughly 3% of all donor money raised across the three committees this cycle. The donor pool is again heavy with Permian Basin oil and gas names (Midland Energy, Don Evans Group) alongside national trade-association PACs (realtors, cattlemen, telecom).

## Major Spending

Setting the $2.32M in inter-committee transfers aside, the real spending breaks down as:

- **Administrative/salary/overhead — $1.77M** (812 items), including Gusto payroll ($151,098), CFS Compliance ($120,725), and Norfleet Strategies ($95,587).
- **Solicitation and fundraising — $934K** (144 items), led by Lilly & Company ($570,523) and a **$66,947** tab at Cooper's BBQ in Christoval, TX — a home-turf fundraising venue rather than a D.C. one this time.
- **Political contributions — $783K** (218 items), plus $492,009 sent directly to the NRCC.
- **Advertising — $565K** (50 items), led by Targeted Creative Communications ($82,966).
- **Travel — $174K** (79 items), including $102,619 at the Ritz-Carlton Pentagon City — the single largest lodging line in this report.

American Express is again the largest nominal vendor at $750,028, but 220 lump card payments totaling $1,071,283 are 92.8% itemized in memo sub-transactions. Inside them: **American Airlines $135,399**; a payment simply labeled **"Baughman, Andrew" $81,822**, in Washington, DC — a name rather than a business, worth a closer look at the underlying memo descriptions before drawing conclusions; **Stein Eriksen Lodge (Park City, UT) $39,451**; and **Capitol Hill Club $21,750**. The Stein Eriksen Lodge charge recurs from the 2022 cycle (see `2022-unopposed.md`) — the same Park City ski resort shows up as a donor-cultivation venue two cycles running.

## Takeaways

1. **A blowout race still ran a multi-million-dollar operation.** With no Democratic opponent and only token Libertarian competition, Pfluger's committees still raised nearly $5M and spent nearly $6.8M. Only $565K of that (8%) was advertising — the bulk went to overhead, fundraising costs, and $783K in political contributions to other Republicans, reinforcing that this is fundraising-and-influence infrastructure, not persuasion spending aimed at Texas voters.

2. **A single Midland donor again anchors the JFC.** Syed Anwar's $150,000 is the largest single check in this cycle's data, continuing the same relationship visible in the 2026-cycle report (where his contribution had grown to $642,100). The escalation across cycles is itself a data point.

3. **A House Ethics stock sale disclosed nearly a year late.** One Periodic Transaction Report on file (`20030737.pdf`) shows a SiriusXM Holdings sale with a transaction date of **2024-09-10** — squarely inside this cycle — but a notification/filing date of **2025-07-25**, roughly 10.5 months later. The House Ethics rules require disclosure within 45 days of notification of a transaction; if the extracted dates are read correctly, that's a significant lateness worth flagging rather than treating as routine. (See the Methodology caveat below on the reliability of this PDF text extraction before treating the dates as certain.)

4. **Recurring luxury fundraising venues, not one-off spending.** The Ritz-Carlton Pentagon City ($102,619 in travel) and Stein Eriksen Lodge ($39,451) both echo the "high-end relational fundraising" pattern already documented for the 2026 cycle — this isn't a one-cycle anomaly, it's the standing operating model.

5. **PAC-to-PAC recycling dominates the donor list.** Half of the top-10 donors above are PACs splitting identical or near-identical checks across two or three of Pfluger's own committees on the same day (Valero PAC, KochPAC, NAR PAC, Cattlemen's PAC) — a routine but easy-to-miss detail if only one committee's report is read in isolation.

## Suggested Committees for Further Investigation

Everything Pfluger controls (principal, leadership PAC, JFC) is already collected. From the local transfer-recipient data, one committee stands out as a deliberate follow-up:

- **NRCC [C00075820]** — received **$492,009** from Pfluger's committees this cycle. As in the 2026-cycle report, full itemization would pull in an enormous, mostly-unrelated national-party dataset; if pursued at all, `--with-affiliated` for totals-only context is the appropriate depth, not a full `--download`.

No other uncollected committee received a large enough share to warrant individual pursuit this cycle; the roughly 150 candidate committees receiving $1,000–$14,000 apiece from Raptor PAC are a breadth-of-giving pattern, not individually notable, and are already fully visible in the local data.

## Methodology & AI Transparency

- **Model:** Claude Sonnet 5 (`claude-sonnet-5`), running in Claude Code (VS Code extension). Temperature and token-limit settings are the Claude Code harness defaults; they are not user-configured or exposed per-request in this environment.
- **Committees analyzed (all three itemized, 2024 cycle only):**
  - C00719294 — August Pfluger for Congress (principal)
  - C00749481 — Raptor PAC (leadership PAC)
  - C00753913 — Pfluger Victory Fund (JFC)
- **Command run:**
  ```bash
  ruby tooling/analyze-candidate.rb \
    --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics \
    --cycle 2024
  ```
- **Data provenance:** None of the three committee directories contain `.download-progress` or `.meta` marker files, and their CSVs carry fec.gov export-UI timestamp names, indicating all three were collected manually via the FEC website's CSV export rather than by `fec-api-client.rb --download`. The empty `PRINCIPAL` marker file identifies C00719294.
- **Data-integrity checks that shaped the findings:**
  - No `EFILE COVERAGE WARNING` was triggered for this cycle — the raw-efile gap-fill (see `tooling/analyze-candidate.rb`'s gotcha 8 and the v7 prompt-history note) only extends into 2026, outside the 2024 window, so it doesn't affect this report.
  - The tool's global cycle-integrity check flagged 558 rows across all cycles where `fec_election_year` disagrees with `two_year_transaction_period`. Of those, 221 rows totaling roughly **$55,081** fall inside the 2024 `two_year_transaction_period` bucket used for this report (mostly WinRed-conduit earmarks tagged for the 2026 or 2023 election year but processed within the 2024 window). That's about 1.1% of this report's $4.99M receipts total — small enough not to change any figure materially, but noted per this tool's standing caution to spot-check rather than assume.
  - The $750K American Express line would naively read as an opaque mega-vendor; the memo back-reference breakdown (92.8% of $1,071,283 in lump card payments itemized at the merchant level) is where the airline/lodging/club findings above come from.
  - House Ethics PDF figures are best-effort text extraction of AcroForm layouts (see the tool's header for known extraction gotchas); the "$200?" artifacts visible in raw extraction are OCR/layout noise from a late-filing-fee notice line, not a dollar figure to report. The late-filing date discussed in Takeaway 3 should be verified against the source PDF before being treated as certain.
- **Output filename note:** The v7 prompt template below specifies `$CANDIDATE_DIR/README.md` as the default output path. Per explicit user instruction, this report was instead saved to `tx-11/august-pfluger/reports/2024-no-democrats.md` so it sits alongside similar historical-context reports for the 2022 and 2020 cycles without overwriting the current-cycle (2026) `README.md`.
- **Exact prompt used** (v7 template with `$CANDIDATE`/`$DISTRICT`/`$CYCLE` filled in):

<details>
<summary>Full verbatim prompt</summary>

````text
CANDIDATE: `August Pfluger`
DISTRICT: `TX-11`
CYCLE: `2024`

Every `$CANDIDATE` / `$DISTRICT` below is that same substitution. `$CANDIDATE_DIR` is not filled in separately — derive it from $CANDIDATE and $DISTRICT using the convention already shown in "Process" above (lowercased district + kebab-case candidate name, e.g. `TX-11` + `August Pfluger` → `tx-11/august-pfluger`); if a close-but-not-exact match already exists under `tx-*/`, use that directory instead of creating a new one.

**Prompt history (v7):** A v6 run on Claire Reynolds's committee (TX-11, C00929711) reported her donor/spending activity as ending 2026-03-31, silently missing an entire second quarter (April–June 2026) that the campaign had already filed. The cause: `analyze-candidate.rb` only ever read `schedule_a-*.csv`/`schedule_b-*.csv` — fec.gov's "processed" bulk exports — and those can lag well behind what's actually been filed, sometimes by months, with no warning that they're stale. The raw `efile-*.csv` data sitting in the same directory (from clicking "Raw data" during Step 1's manual export, or from `fec-api-client.rb`'s automated download) already had the missing quarter; the tool just never looked at it. `analyze-candidate.rb` now reads `efile-*.csv` itself — but only ever for the narrow slice of rows dated strictly after whatever date the processed schedule_a/schedule_b export already covers, and only once per committee/schedule. It never touches or re-derives anything for a period the processed files already cover, which is what keeps this safe against the double-counting risk that kept efile out of scope entirely before (v6 and earlier told this prompt to never glob `efile-*.csv` in at all — see the v6 note below for why that caution existed, and gotcha 8 in `tooling/analyze-candidate.rb`'s header for the amendment-handling and name-casing details that make gap-filling correct rather than just plausible-looking). Nothing changed in this prompt's own instructions to make this happen — v7 exists only to record the incident and point at the tool as the actual fix, per this repo's standing rule that data-integrity logic lives in `analyze-candidate.rb`'s header, not duplicated here. One thing this prompt now does ask for explicitly: if the tool's output includes an `EFILE COVERAGE WARNING` banner, say so in the Methodology section (see the updated Methodology instructions below) rather than letting it pass unremarked — the whole point of surfacing it is so a reader can tell the difference between "no more recent filings exist" and "more recent filings exist and are already reflected below."

**Prompt history (v6):** v5 restricted this prompt to the principal committee **only**, even if other committees (a JFC, a leadership PAC) were already sitting collected in `$CANDIDATE_DIR/fec/`. That was overcorrection: the actual invariant Step 2 needs to hold is "never download, itemize, or otherwise collect anything itself" — not "only ever look at one committee." A user (or an LLM doing Step 1 as its own deliberate task) might already know a candidate's JFC matters and go collect it manually before ever running this prompt — say, because they read a prior "Suggested Committees" note, or just already knew about Raptor PAC and Pfluger Victory Committee and grabbed them alongside the principal committee from the start. Refusing to use data that's already sitting on disk, correctly collected, would be perverse. v6 analyzes **everything already collected** under `$CANDIDATE_DIR/fec/` — one committee or several — and reserves "Suggested Committees for Further Investigation" for naming committees that are visible but *not yet* collected, exactly as before.

**Prompt history (v5):** v4 still had this prompt run `fec-api-client.rb --download` itself, right before the analysis step, on the theory that a "principal committee only" download was narrow enough to be safe. In practice that still meant an analysis prompt could reach for the network and decide, on its own, that data needed fetching — the same instinct that led earlier versions to auto-chase linked/affiliated committees. v5 removes the download command from this prompt entirely. Collection (Step 1) and analysis (Step 2) are now strictly separate: if the required `fec/` data isn't already on disk when this prompt runs, **stop and say so** — tell the user which committee ID(s) to collect and point them at "Step 1: Collect Your Data" above — rather than fetching it yourself. This also makes the iterative workflow explicit: fast-pass on just the principal committee, read what it suggests investigating, go collect those committees yourself (Step 1 again, deliberately), then re-run this same analysis prompt against the now-larger `fec/` directory.

**Prompt history (v4):** v3 had this prompt download the principal committee's data plus, via a `--with-affiliated` flag, another committee auto-discovered by name search (and before that, a `--with-linked` flag that recursively crawled every committee ever referenced in a Schedule B transfer). Both put the *tool* in charge of deciding which other committees mattered — which either missed the committee that actually carried most of a candidate's money (a JFC's name search can fail; see `tooling/fec-api-client.rb`'s header) or, worse, pulled in large, unrelated committees (a party committee, another candidate's committee) that happened to receive a transfer. v4 scoped this prompt to the principal committee **only**, with `analyze-candidate.rb`'s own Schedule B data (a `recipient_committee_id` for any transfer recipient that's itself a committee — zero extra API calls) feeding a "Suggested Committees for Further Investigation" output section instead of an automatic download.

**Prompt history:** the pilot run of this prompt (TX-11/August-Pfluger) shipped a summary with a "Correction (post-publication review)" section — it took a second pass, prompted by a human asking pointed questions, to catch a couple of data-integrity bugs after the fact. Both are now fixed in [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) and documented in its header comments, not repeated here — see the note below on why. This prompt tells the model to read and reuse that tool up front, specifically so a fresh session doesn't rediscover the same bugs before it can trust its own numbers. A "Correction" section in the output is a sign this prompt or the tool needs another pass, not an acceptable steady state.

**Tooling requirements:** Any tooling written to perform this analysis must be written in Ruby, using the version pinned in [`.ruby-version`](.ruby-version). Save all tooling artifacts (scripts, Rakefiles, etc.) to the `/tooling` directory. Gems should be managed normally with Bundler and a `Gemfile`, so the repo remains portable and reproducible for anyone with `rbenv` and `bundler` installed. **Before writing anything new, check whether [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) already exists and covers this candidate's data** (`ruby tooling/analyze-candidate.rb --help` shows its interface — run as plain `ruby`, not `bundle exec ruby`; see "Running the tool" under Step 2 below for why). It's built to be reused across candidates via `--fec-dir` / `--house-ethics-dir` arguments — extend it in place if a candidate's filings need something it doesn't handle yet, rather than writing a parallel one-off script. **Read that file's header comments in full before trusting or reporting any total** — they hold the specific, tested data-integrity gotchas (duplicate/amended filings, dropped correction rows, lump-sum vendor payments that look unitemized but aren't, and more) as close to the code they explain as possible, so they stay accurate as the tool changes instead of drifting out of sync with a second copy kept here.

**Analyze financial disclosure documents for August Pfluger (TX-11) and create an executive summary for the 2024 election cycle only.**

**Scope:** This analysis covers **every committee already collected** under `tx-11/august-pfluger/fec/` as of when this prompt runs — that might be just the principal committee, or it might already include a JFC, leadership PAC, or other committee the user (or a prior Step 1 pass) deliberately gathered alongside it. Use all of it; `analyze-candidate.rb` folds every locally-present committee's itemized data into one combined analysis automatically, whether that's one committee or several. What this prompt must **not** do is collect anything new itself — don't download, itemize, or otherwise pull in data for any committee that isn't already sitting in `fec/`, even if one is named or visible in already-downloaded data (e.g. a JFC's name showing up in a Schedule A transfer row) — see "Suggested Committees for Further Investigation" below for how to handle those instead. Also cover **only** transactions dated within the 2024 election cycle (filed in 2024); do not include historical cycles or outdated filings, even if older data exists in the source files.

**Before doing anything else, verify the data is already collected:** check that `tx-11/august-pfluger/fec/` contains at least one committee subdirectory (matching `C\d{6,}`) with `schedule_a-*.csv` / `schedule_b-*.csv` files in it — there may be just one, or several. **If there are none at all, stop here.** Tell the user data collection hasn't happened yet, point them at "Step 1: Collect Your Data" in this README, and do not run `fec-api-client.rb --download` yourself to fill the gap — that decision (which committee(s), how much history, itemized vs. totals) belongs to Step 1, not to this analysis prompt.

**Once the data is confirmed present, run this:**

    ruby tooling/analyze-candidate.rb \
      --fec-dir tx-11/august-pfluger/fec \
      --house-ethics-dir tx-11/august-pfluger/house-ethics \
      --cycle 2024

Use the output as your source data. The tool filters transactions to the specified cycle and documents any data-integrity warnings, including a list of committees seen as Schedule B transfer recipients (raw material for the Suggested Committees section — the tool does not download or itemize these itself) and, if present, an `EFILE COVERAGE WARNING` banner (see gotcha 8 in the tool's header) showing that raw efile data extending past the processed schedule_a/schedule_b export's own coverage has already been folded into the totals below it. Read the tool's header comments (in `/tooling/analyze-candidate.rb`) to understand how it handles multi-cycle data, amendments, and efile gap-filling.

**Output:**
- Format: Markdown
- Filename: `tx-11/august-pfluger/README.md`
- Length: Main analysis should be roughly 2,000 words. The complete Methodology & AI Transparency section (including the full verbatim prompt) doesn't count against this word limit.
- Title: `TX-11: August Pfluger — Financial Disclosure Summary (2024 Cycle)`

**Content sections (in this order):**

1. **Key Donors** — Top 5-10 individual/corporate donors by contribution amount in the 2024 cycle, drawn from every committee already collected under `tx-11/august-pfluger/fec/` (just the principal committee, or that plus a JFC/leadership PAC/other committee if those were already gathered too). Include amounts and donor affiliation where relevant. If a large share of the candidate's money likely moved through a committee that is **not** locally collected, say so plainly rather than implying this list is the complete donor picture.

2. **Major Spending** — Top disbursements by category (e.g., staff, consulting, media, events) in the 2024 cycle. Highlight any unusual or notable expenditures.

3. **Takeaways** — 3-5 findings that are newsworthy, unexpected, or revealing about the candidate's priorities, funding sources, or spending patterns in the 2024 cycle. Examples: unusual donor relationships, spending that contradicts public messaging, geographic patterns, or high-interest items like luxury dining or travel.

4. **Suggested Committees for Further Investigation** — A short, judgment-based list (not an exhaustive dump) of committees that are **not yet collected** under `tx-11/august-pfluger/fec/` but worth a deliberate follow-up look, drawn **only from data already local** — `analyze-candidate.rb`'s "committees seen as transfer recipients" list, or a committee name/ID already visible somewhere in the already-downloaded CSVs (e.g. a JFC named in a Schedule A "Transfers from authorized committees" row) that hasn't itself been collected yet. Do not make a live API call (e.g. to check `affiliated_committee_name`) to populate this section — that would itself be a collection action, which this prompt doesn't do. For each committee named, note why it might matter and how a human would pursue it later (`fec-api-client.rb --download --committee-id <id>` for full itemized data, or `--with-affiliated` for totals only — see "We Must Go Deeper!"). If everything obviously relevant already appears to be collected, say so briefly rather than padding this section. This section is explicitly a pointer for a human's future Step 1 pass, not a second analysis now — don't itemize or deep-dive any newly-named committee in this same run, even though you're free to fully use whatever's already collected in the sections above.

5. **Methodology & AI Transparency** — Disclose the LLM model name/version (e.g., Claude 3.5 Sonnet), key configuration settings (temperature, token limits), and the exact prompt used to generate this analysis (i.e. this template with $CANDIDATE/$DISTRICT/$CYCLE filled in). List every committee ID actually analyzed (there may be more than one). Include the exact `analyze-candidate.rb` command you ran, and note (without re-running them) which `fec-api-client.rb --download`/manual-export steps originally populated each committee directory this analysis reads from, if that's discoverable (e.g. from `.download-progress` marker files, or their absence if the committee was collected manually) — so a reader can tell what data collection actually happened, even though this analysis pass didn't perform it. This transparency allows readers to understand how findings were produced, assess potential model limitations or biases, and reproduce the analysis if desired. If applying `analyze-candidate.rb`'s data-integrity gotchas changed a finding versus a naive read of the data, say so briefly here instead of adding a separate correction section — this prompt already expects that check to happen before publication, not after. If the tool's output included an `EFILE COVERAGE WARNING` banner for any committee, state that plainly here too: which committee(s)/schedule(s), the date range the processed export was missing, and roughly how much money that added — so a reader can tell the difference between "no more recent filings exist" and "more recent filings exist and this report already reflects them."

**Tone:** Analytical, conversational for a general political audience. Avoid jargon; explain significance where needed.

**Source:** FEC and House Ethics Committee disclosures in the `tx-11/august-pfluger/` directory, filtered to the 2024 cycle and to whichever committees were already collected there as of this run.
````

</details>
