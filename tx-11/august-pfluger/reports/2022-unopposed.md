# TX-11: August Pfluger — Financial Disclosure Summary (2022 Cycle)

Per `historical-election-results.md`, the 2022 race is the cleanest case in Pfluger's electoral history: "truly unopposed — no opponent of any party," with a final result of 151,066 to zero. There was no general-election opponent to campaign against and no ballot line to compete on. That makes 2022 the sharpest test of the question this report set asks: what does the money do when there is, quite literally, no one to beat? As in the other cycles, three committees carry the story — the principal campaign committee (**August Pfluger for Congress**, C00719294), the leadership PAC (**Raptor PAC**, C00749481), and the joint fundraising committee (**Pfluger Victory Fund**, C00753913) — all three already collected locally.

Combined itemized donor receipts across the three committees total **$4,269,147** for the 2022 cycle — 82% from individuals ($3.52M) and 18% from PACs and other committees ($752K). Combined disbursements were **$5,305,346**, of which **$2,299,971** (43%) is inter-committee transfers.

## Key Donors

| Donor | Amount | Affiliation |
|---|---|---|
| Syed J. Anwar (Midland, TX) | **$165,800** | President/CEO, Midland Energy — Permian Basin oil |
| Gayla Mabee (Midland, TX) | $75,000 | Homemaker |
| John Mabee (Midland, TX) | $75,000 | Manager, Mabee Ranch |
| Elizabeth Qualls (Houston, TX) | $50,000 | Individual donor |
| William Kent (Midland, TX) | $26,600 | Chairman/CEO, The Kent Companies |
| Cool Master Pro (Tampa, FL) | $25,000 | Corporate entity donor |
| Scott A. Wisniewski (San Angelo, TX) | $25,000 | Owner, Western Shamrock Corp (consumer finance) |
| Micheal Till (Spring, TX) | $25,000 | Owner, MTill Holdings LLC |
| Donald L. Evans (Midland, TX) | $23,700 | President, The Don Evans Group |
| Jennifer Hord (Midland, TX) | $23,700 | Homemaker |

Every one of these gave through the Pfluger Victory Fund JFC, not the campaign committee directly — the same structural pattern documented in the 2026 and 2024 reports. Anwar's $165,800 is nearly 4% of all donor money raised across the three committees this unopposed cycle, and it's larger, in raw dollars, than his contribution in either of the other two cycles analyzed here. The list again skews heavily toward Midland/Permian Basin energy money and consumer-finance/real-estate wealth, with comparatively few PACs cracking the top 10 — a contrast with the more PAC-heavy top-10 lists in the 2020 and 2024 reports.

## Major Spending

Setting the $2.3M in inter-committee transfers aside:

- **Administrative/salary/overhead — $1.08M** (598 items), including Upstream Communications ($182,498) and Dylan Sanders ($55,117, San Angelo).
- **Advertising — $628K** (29 items), led by NRCC ($576,843, categorized here as an advertising-purpose disbursement rather than a plain transfer) and Targeted Victory ($248,998).
- **Solicitation and fundraising — $581K** (84 items), led by Lilly & Company ($264,645) and Hooks Solutions ($205,607).
- **Political contributions — $432K** (282 items).
- **Polling — $31,300** (2 items) — notable on its own terms; see Takeaways below.

American Express ($514,872) is the top nominal payee outside of transfers. 142 lump card payments totaling $585,012 are 93.9% itemized in memo sub-transactions, revealing: **American Airlines $49,449**; **Century Graphics & Sign $49,256**; **Montage Deer Valley (Park City, UT) $25,000**; and **Stein Eriksen Lodge (also Park City, UT) $17,681**. Two different luxury ski-resort properties in the same mountain town, in the same cycle, is a pattern rather than a coincidence — and Stein Eriksen Lodge recurs again in the 2024-cycle data (see `2024-no-democrats.md`).

## Takeaways

1. **A genuinely unopposed race still moved $4.27M in and $5.3M out.** With zero opposition of any party, there was no persuasion audience to spend on — and the disbursement categories bear that out. This is fundraising-network and party-building spending, not campaign spending in the ordinary sense.

2. **Polling in a race with no opponent is the standout anomaly.** $31,300 across two polling-expense line items in a cycle where the general-election result was literally uncontested is hard to explain as candidate self-defense. The more plausible reads are testing messaging for a future statewide or leadership ambition, or polling on behalf of the broader conference/committee — but the local data doesn't itemize the pollster's actual questions, so this is flagged as a finding worth follow-up, not a settled conclusion.

3. **Two Park City ski-resort charges in one cycle.** Montage Deer Valley ($25,000) and Stein Eriksen Lodge ($17,681) both appear as vendors behind lump card payments in the same cycle — donor-retreat-style spending that predates and matches the pattern already documented in the 2026-cycle README, showing this is a standing practice rather than a one-off.

4. **A large early transfer, six months after taking office.** The single largest disbursement in this cycle's data is a **$321,642** transfer from the campaign committee dated **2021-06-28** — early war-chest consolidation well before any opposition (or lack thereof) was known for 2022, consistent with routine post-election account-clearing rather than anything race-specific.

5. **The JFC again hides most of the money from a single-committee view.** As in every cycle examined so far, anyone reading only the principal committee's report would see roughly $1.53M and miss more than half the total raised; the Pfluger Victory Fund JFC alone brought in $2.63M.

## Suggested Committees for Further Investigation

Everything Pfluger controls (principal, leadership PAC, JFC) is already collected. From the local transfer-recipient data, one committee stands out:

- **NRCC [C00075820]** — received **$576,843** from Pfluger's committees this cycle, the largest outside recipient and, notably, categorized in the local data as an advertising-purpose disbursement rather than a plain transfer (worth a closer read of the underlying memo text before assuming it's identical in kind to the transfers seen in other cycles). As before, full itemization would pull in a large, mostly-unrelated national-party dataset; `--with-affiliated` for totals-only context is the appropriate depth if pursued at all.

No other uncollected committee received a large enough share this cycle to warrant individual pursuit; the many $1,000–$5,000 checks to other Republican candidate committees are a breadth-of-giving pattern already fully visible locally, not individually notable.

## Methodology & AI Transparency

- **Model:** Claude Sonnet 5 (`claude-sonnet-5`), running in Claude Code (VS Code extension). Temperature and token-limit settings are the Claude Code harness defaults; they are not user-configured or exposed per-request in this environment.
- **Committees analyzed (all three itemized, 2022 cycle only):**
  - C00719294 — August Pfluger for Congress (principal)
  - C00749481 — Raptor PAC (leadership PAC)
  - C00753913 — Pfluger Victory Fund (JFC)
- **Command run:**
  ```bash
  ruby tooling/analyze-candidate.rb \
    --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics \
    --cycle 2022
  ```
- **Data provenance:** None of the three committee directories contain `.download-progress` or `.meta` marker files, and their CSVs carry fec.gov export-UI timestamp names, indicating all three were collected manually via the FEC website's CSV export rather than by `fec-api-client.rb --download`. The empty `PRINCIPAL` marker file identifies C00719294.
- **Data-integrity checks that shaped the findings:**
  - No `EFILE COVERAGE WARNING` was triggered for this cycle — the raw-efile gap-fill only extends into 2026, well outside the 2022 window, so it doesn't affect this report.
  - The tool's global cycle-integrity check flagged 558 rows across all cycles where `fec_election_year` disagrees with `two_year_transaction_period`. Of those, **110 rows totaling roughly $97,785** fall inside the 2022 `two_year_transaction_period` bucket used for this report — mostly WinRed-conduit earmarks processed in the 2022 calendar window but tagged by the donor for the 2020 or 2024 election year. That's about 2.3% of this report's $4.27M receipts total, the largest relative share of any of the three cycles examined in this set of reports, and is called out here specifically so it isn't mistaken for a clean number.
  - The House Ethics filings collected locally (`house-ethics/`) are all Periodic Transaction Reports with transaction dates in 2024–2026 — none fall within the 2022 cycle window, so this report has no House Ethics content to draw on; that's a gap in the local collection for this period, not evidence that no reportable trades occurred in 2022.
  - American Express's $514,872 line would naively read as an opaque mega-vendor; the memo back-reference breakdown (93.9% of $585,012 in lump card payments itemized at the merchant level) is where the airline/resort findings above come from.
- **Output filename note:** The v7 prompt template below specifies `$CANDIDATE_DIR/README.md` as the default output path. Per explicit user instruction, this report was instead saved to `tx-11/august-pfluger/reports/2022-unopposed.md` so it sits alongside similar historical-context reports for the 2024 and 2020 cycles without overwriting the current-cycle (2026) `README.md`.
- **Exact prompt used** (v7 template with `$CANDIDATE`/`$DISTRICT`/`$CYCLE` filled in):

<details>
<summary>Full verbatim prompt</summary>

````text
CANDIDATE: `August Pfluger`
DISTRICT: `TX-11`
CYCLE: `2022`

Every `$CANDIDATE` / `$DISTRICT` below is that same substitution. `$CANDIDATE_DIR` is not filled in separately — derive it from $CANDIDATE and $DISTRICT using the convention already shown in "Process" above (lowercased district + kebab-case candidate name, e.g. `TX-11` + `August Pfluger` → `tx-11/august-pfluger`); if a close-but-not-exact match already exists under `tx-*/`, use that directory instead of creating a new one.

**Prompt history (v7):** A v6 run on Claire Reynolds's committee (TX-11, C00929711) reported her donor/spending activity as ending 2026-03-31, silently missing an entire second quarter (April–June 2026) that the campaign had already filed. The cause: `analyze-candidate.rb` only ever read `schedule_a-*.csv`/`schedule_b-*.csv` — fec.gov's "processed" bulk exports — and those can lag well behind what's actually been filed, sometimes by months, with no warning that they're stale. The raw `efile-*.csv` data sitting in the same directory (from clicking "Raw data" during Step 1's manual export, or from `fec-api-client.rb`'s automated download) already had the missing quarter; the tool just never looked at it. `analyze-candidate.rb` now reads `efile-*.csv` itself — but only ever for the narrow slice of rows dated strictly after whatever date the processed schedule_a/schedule_b export already covers, and only once per committee/schedule. It never touches or re-derives anything for a period the processed files already cover, which is what keeps this safe against the double-counting risk that kept efile out of scope entirely before (v6 and earlier told this prompt to never glob `efile-*.csv` in at all — see the v6 note below for why that caution existed, and gotcha 8 in `tooling/analyze-candidate.rb`'s header for the amendment-handling and name-casing details that make gap-filling correct rather than just plausible-looking). Nothing changed in this prompt's own instructions to make this happen — v7 exists only to record the incident and point at the tool as the actual fix, per this repo's standing rule that data-integrity logic lives in `analyze-candidate.rb`'s header, not duplicated here. One thing this prompt now does ask for explicitly: if the tool's output includes an `EFILE COVERAGE WARNING` banner, say so in the Methodology section (see the updated Methodology instructions below) rather than letting it pass unremarked — the whole point of surfacing it is so a reader can tell the difference between "no more recent filings exist" and "more recent filings exist and are already reflected below."

**Prompt history (v6):** v5 restricted this prompt to the principal committee **only**, even if other committees (a JFC, a leadership PAC) were already sitting collected in `$CANDIDATE_DIR/fec/`. That was overcorrection: the actual invariant Step 2 needs to hold is "never download, itemize, or otherwise collect anything itself" — not "only ever look at one committee." A user (or an LLM doing Step 1 as its own deliberate task) might already know a candidate's JFC matters and go collect it manually before ever running this prompt — say, because they read a prior "Suggested Committees" note, or just already knew about Raptor PAC and Pfluger Victory Committee and grabbed them alongside the principal committee from the start. Refusing to use data that's already sitting on disk, correctly collected, would be perverse. v6 analyzes **everything already collected** under `$CANDIDATE_DIR/fec/` — one committee or several — and reserves "Suggested Committees for Further Investigation" for naming committees that are visible but *not yet* collected, exactly as before.

**Prompt history (v5):** v4 still had this prompt run `fec-api-client.rb --download` itself, right before the analysis step, on the theory that a "principal committee only" download was narrow enough to be safe. In practice that still meant an analysis prompt could reach for the network and decide, on its own, that data needed fetching — the same instinct that led earlier versions to auto-chase linked/affiliated committees. v5 removes the download command from this prompt entirely. Collection (Step 1) and analysis (Step 2) are now strictly separate: if the required `fec/` data isn't already on disk when this prompt runs, **stop and say so** — tell the user which committee ID(s) to collect and point them at "Step 1: Collect Your Data" above — rather than fetching it yourself. This also makes the iterative workflow explicit: fast-pass on just the principal committee, read what it suggests investigating, go collect those committees yourself (Step 1 again, deliberately), then re-run this same analysis prompt against the now-larger `fec/` directory.

**Prompt history (v4):** v3 had this prompt download the principal committee's data plus, via a `--with-affiliated` flag, another committee auto-discovered by name search (and before that, a `--with-linked` flag that recursively crawled every committee ever referenced in a Schedule B transfer). Both put the *tool* in charge of deciding which other committees mattered — which either missed the committee that actually carried most of a candidate's money (a JFC's name search can fail; see `tooling/fec-api-client.rb`'s header) or, worse, pulled in large, unrelated committees (a party committee, another candidate's committee) that happened to receive a transfer. v4 scoped this prompt to the principal committee **only**, with `analyze-candidate.rb`'s own Schedule B data (a `recipient_committee_id` for any transfer recipient that's itself a committee — zero extra API calls) feeding a "Suggested Committees for Further Investigation" output section instead of an automatic download.

**Prompt history:** the pilot run of this prompt (TX-11/August-Pfluger) shipped a summary with a "Correction (post-publication review)" section — it took a second pass, prompted by a human asking pointed questions, to catch a couple of data-integrity bugs after the fact. Both are now fixed in [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) and documented in its header comments, not repeated here — see the note below on why. This prompt tells the model to read and reuse that tool up front, specifically so a fresh session doesn't rediscover the same bugs before it can trust its own numbers. A "Correction" section in the output is a sign this prompt or the tool needs another pass, not an acceptable steady state.

**Tooling requirements:** Any tooling written to perform this analysis must be written in Ruby, using the version pinned in [`.ruby-version`](.ruby-version). Save all tooling artifacts (scripts, Rakefiles, etc.) to the `/tooling` directory. Gems should be managed normally with Bundler and a `Gemfile`, so the repo remains portable and reproducible for anyone with `rbenv` and `bundler` installed. **Before writing anything new, check whether [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) already exists and covers this candidate's data** (`ruby tooling/analyze-candidate.rb --help` shows its interface — run as plain `ruby`, not `bundle exec ruby`; see "Running the tool" under Step 2 below for why). It's built to be reused across candidates via `--fec-dir` / `--house-ethics-dir` arguments — extend it in place if a candidate's filings need something it doesn't handle yet, rather than writing a parallel one-off script. **Read that file's header comments in full before trusting or reporting any total** — they hold the specific, tested data-integrity gotchas (duplicate/amended filings, dropped correction rows, lump-sum vendor payments that look unitemized but aren't, and more) as close to the code they explain as possible, so they stay accurate as the tool changes instead of drifting out of sync with a second copy kept here.

**Analyze financial disclosure documents for August Pfluger (TX-11) and create an executive summary for the 2022 election cycle only.**

**Scope:** This analysis covers **every committee already collected** under `tx-11/august-pfluger/fec/` as of when this prompt runs — that might be just the principal committee, or it might already include a JFC, leadership PAC, or other committee the user (or a prior Step 1 pass) deliberately gathered alongside it. Use all of it; `analyze-candidate.rb` folds every locally-present committee's itemized data into one combined analysis automatically, whether that's one committee or several. What this prompt must **not** do is collect anything new itself — don't download, itemize, or otherwise pull in data for any committee that isn't already sitting in `fec/`, even if one is named or visible in already-downloaded data (e.g. a JFC's name showing up in a Schedule A transfer row) — see "Suggested Committees for Further Investigation" below for how to handle those instead. Also cover **only** transactions dated within the 2022 election cycle (filed in 2022); do not include historical cycles or outdated filings, even if older data exists in the source files.

**Before doing anything else, verify the data is already collected:** check that `tx-11/august-pfluger/fec/` contains at least one committee subdirectory (matching `C\d{6,}`) with `schedule_a-*.csv` / `schedule_b-*.csv` files in it — there may be just one, or several. **If there are none at all, stop here.** Tell the user data collection hasn't happened yet, point them at "Step 1: Collect Your Data" in this README, and do not run `fec-api-client.rb --download` yourself to fill the gap — that decision (which committee(s), how much history, itemized vs. totals) belongs to Step 1, not to this analysis prompt.

**Once the data is confirmed present, run this:**

    ruby tooling/analyze-candidate.rb \
      --fec-dir tx-11/august-pfluger/fec \
      --house-ethics-dir tx-11/august-pfluger/house-ethics \
      --cycle 2022

Use the output as your source data. The tool filters transactions to the specified cycle and documents any data-integrity warnings, including a list of committees seen as Schedule B transfer recipients (raw material for the Suggested Committees section — the tool does not download or itemize these itself) and, if present, an `EFILE COVERAGE WARNING` banner (see gotcha 8 in the tool's header) showing that raw efile data extending past the processed schedule_a/schedule_b export's own coverage has already been folded into the totals below it. Read the tool's header comments (in `/tooling/analyze-candidate.rb`) to understand how it handles multi-cycle data, amendments, and efile gap-filling.

**Output:**
- Format: Markdown
- Filename: `tx-11/august-pfluger/README.md`
- Length: Main analysis should be roughly 2,000 words. The complete Methodology & AI Transparency section (including the full verbatim prompt) doesn't count against this word limit.
- Title: `TX-11: August Pfluger — Financial Disclosure Summary (2022 Cycle)`

**Content sections (in this order):**

1. **Key Donors** — Top 5-10 individual/corporate donors by contribution amount in the 2022 cycle, drawn from every committee already collected under `tx-11/august-pfluger/fec/` (just the principal committee, or that plus a JFC/leadership PAC/other committee if those were already gathered too). Include amounts and donor affiliation where relevant. If a large share of the candidate's money likely moved through a committee that is **not** locally collected, say so plainly rather than implying this list is the complete donor picture.

2. **Major Spending** — Top disbursements by category (e.g., staff, consulting, media, events) in the 2022 cycle. Highlight any unusual or notable expenditures.

3. **Takeaways** — 3-5 findings that are newsworthy, unexpected, or revealing about the candidate's priorities, funding sources, or spending patterns in the 2022 cycle. Examples: unusual donor relationships, spending that contradicts public messaging, geographic patterns, or high-interest items like luxury dining or travel.

4. **Suggested Committees for Further Investigation** — A short, judgment-based list (not an exhaustive dump) of committees that are **not yet collected** under `tx-11/august-pfluger/fec/` but worth a deliberate follow-up look, drawn **only from data already local** — `analyze-candidate.rb`'s "committees seen as transfer recipients" list, or a committee name/ID already visible somewhere in the already-downloaded CSVs (e.g. a JFC named in a Schedule A "Transfers from authorized committees" row) that hasn't itself been collected yet. Do not make a live API call (e.g. to check `affiliated_committee_name`) to populate this section — that would itself be a collection action, which this prompt doesn't do. For each committee named, note why it might matter and how a human would pursue it later (`fec-api-client.rb --download --committee-id <id>` for full itemized data, or `--with-affiliated` for totals only — see "We Must Go Deeper!"). If everything obviously relevant already appears to be collected, say so briefly rather than padding this section. This section is explicitly a pointer for a human's future Step 1 pass, not a second analysis now — don't itemize or deep-dive any newly-named committee in this same run, even though you're free to fully use whatever's already collected in the sections above.

5. **Methodology & AI Transparency** — Disclose the LLM model name/version (e.g., Claude 3.5 Sonnet), key configuration settings (temperature, token limits), and the exact prompt used to generate this analysis (i.e. this template with $CANDIDATE/$DISTRICT/$CYCLE filled in). List every committee ID actually analyzed (there may be more than one). Include the exact `analyze-candidate.rb` command you ran, and note (without re-running them) which `fec-api-client.rb --download`/manual-export steps originally populated each committee directory this analysis reads from, if that's discoverable (e.g. from `.download-progress` marker files, or their absence if the committee was collected manually) — so a reader can tell what data collection actually happened, even though this analysis pass didn't perform it. This transparency allows readers to understand how findings were produced, assess potential model limitations or biases, and reproduce the analysis if desired. If applying `analyze-candidate.rb`'s data-integrity gotchas changed a finding versus a naive read of the data, say so briefly here instead of adding a separate correction section — this prompt already expects that check to happen before publication, not after. If the tool's output included an `EFILE COVERAGE WARNING` banner for any committee, state that plainly here too: which committee(s)/schedule(s), the date range the processed export was missing, and roughly how much money that added — so a reader can tell the difference between "no more recent filings exist" and "more recent filings exist and this report already reflects them."

**Tone:** Analytical, conversational for a general political audience. Avoid jargon; explain significance where needed.

**Source:** FEC and House Ethics Committee disclosures in the `tx-11/august-pfluger/` directory, filtered to the 2022 cycle and to whichever committees were already collected there as of this run.
````

</details>
