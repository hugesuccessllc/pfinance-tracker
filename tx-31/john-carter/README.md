# TX-31: John Carter — Financial Disclosure Summary

John R. Carter is the Republican incumbent in Texas's 31st Congressional District, a Williamson County-anchored seat (Round Rock, Georgetown, Killeen, Fort Cavazos) he has held since 2003. Two FEC committees report activity in this filing period: his principal campaign committee, **John Carter for Congress** (C00371203), and his leadership PAC, **Conservative & Republican Together Equals Results PAC** (C00427401). Combined, the two reported **$933,616.36** in itemized receipts and **$1,376,692.96** in itemized disbursements for the period covering roughly January 2025 through June 2026. The campaign committee ended the period with **$170,827.40** cash on hand (up from $41,438.95); the PAC ended with **$32,455.91** (down from $48,920.03), with no debt reported on either side.

## Key Donors

Itemized giving splits 41% individual ($383,805.26) to 59% PAC/committee ($549,811.10) — a donor base weighted toward organized interests rather than grassroots individual checks, typical of a senior incumbent. The largest donors, combining near-duplicate PAC name variants across the two committees:

1. **Lockheed Martin Corporation Employees' PAC** — $20,000.00 ($10,000 to each committee)
2. **General Dynamics Corporation PAC** — $20,000.00 ($10,000 to each committee)
3. **American Society of Anesthesiologists PAC (ASA PAC)** — $20,000.00 ($10,000 to each committee)
4. **Space Exploration Technologies Corp. PAC** (SpaceX) — $25,000.00 ($15,000 to the campaign, $10,000 to the PAC)
5. **Leonardo DRS PAC** — $10,000.00 (Arlington, VA)
6. **BAE Systems USA PAC** — $10,000.00 (Arlington, VA)
7. **"Buckey Libert PAC"** — $10,000.00 (Hudson, WI) — the name as recorded in FEC data; not independently verified beyond the filing
8. **American Institute of Certified Public Accountants PAC** — $10,000.00 (Durham, NC)
9. **Ellison, Lawrence** — $10,000.00, owner of Lawrence Investments, LLC (Walnut Creek, CA) — an individual donor; no connection to any other person or entity of a similar name should be inferred from this filing alone
10. **L3Harris Technologies PAC** — $9,500.00 (split $4,500 campaign / $5,000 PAC)
11. **Glackin, Brian** — $9,500.00, consultant at Brian Glackin Associates, LLC (Washington, DC)

Just outside the top tier: **Honeywell International PAC** ($8,000.00), **Jim Jordan for Congress** ($8,000.00, split evenly between Carter's two committees — a member-to-member transfer from the House Judiciary Chairman's own campaign committee), **Textron PAC** and **The Boeing PAC** ($7,500.00 each), and **Cardoza, Miguel** ($8,500.00, a manager at Trident Research in Georgetown, TX).

Geographically, Virginia ($208,600, 98 contributions — almost entirely defense-contractor PAC money headquartered in the DC suburbs) and Washington, DC ($187,400, 88 contributions) together outweigh Texas itself ($153,638.64, 117 contributions), with Maryland, Florida, California, and Illinois rounding out the rest. For an incumbent from a military-heavy district, that's not surprising, but it does mean the itemized dollars are disproportionately Beltway-sourced relative to the district he represents.

## Major Spending

**Poolhouse Agency LLC** (Richmond, VA) is the single largest payee at **$408,243.00**, entirely booked as "Advertising Expenses — Media Strategy Consulting," in five buys ranging from $37,723 to $161,480 concentrated in January–February 2026, ahead of the March primary. **Chase - Card Member Services** is the second-largest at $338,075.31, booked simply as lump card payments under "Administrative/Salary/Overhead Expenses."

That Chase total looked like an opaque black box at first — the tool's usual method for unpacking these lump card payments (matching memo-coded sub-transactions to their parent payment via `back_reference_transaction_id`) found nothing, because this filer's Schedule B exports never populate that field at all. Rather than accept that as a dead end, the underlying 761 memo-coded rows were pulled directly: they total $303,091.13 in real merchant-level detail (not reconcilable one-to-one against the $338,075.31 lump total, since there's no field linking specific charges to specific statement payments, but clearly the same underlying card spend). The breakdown: $104,906.44 in "Solicitation and Fundraising," $63,958.99 in "Administrative/Salary/Overhead," $62,989.12 in "Travel," $51,294.28 in "Advertising," plus smaller event and materials spend. Top merchants include Facebook ($51,198.40 — digital ads), Robertson and Consulting LLC ($25,298.14 — a Liberty Hill, TX political-strategy consultant paid in card installments rather than direct checks), the Capitol Hill Club ($15,910.72 — the private Washington club for Republican members of Congress), Southwest Airlines ($15,348.62), CVS Pharmacy ($12,463.87), H-E-B ($10,929.73), and a mix of restaurants (Maggiano's, Capital Grille), hotels (Hilton Garden Inn, Homewood Suites), and one golf club (The Golf Club Star Ranch, Hutto, TX, $5,702.79).

Beyond the two headline payees, printing and fundraising overhead run high: **KAP Print, LLC** (Dripping Springs, TX) took $131,899.14 across several ~$28,800 direct-mail buys, and **Drucker Lawhon, LLP** (Washington, DC) took $124,850.20, including a single $35,000 payment labeled "FUNDRAISING COMMISSION." Combined with the card-breakdown's $104,906.44 in fundraising-labeled card spend, total fundraising/solicitation overhead across both committees runs well over $250,000 — roughly a quarter of all itemized disbursements.

Two consultants sharing a surname, **Miller, Chrissie** and **Miller, Jonas**, both listed at the same Round Rock, TX address, were paid a combined $89,000 by the leadership PAC alone (three "commission"-based political-strategy payments, all in the $25,000–$32,000 range). **Prevail Strategies** (Leawood, KS, $30,000) and **RumbleUp** (Washington, DC, $25,000, peer-to-peer texting) round out the PAC's consulting and voter-contact spend, alongside more mundane items like $37,788.60 to Hill Country Payroll (Round Rock, TX) and two $3,900 payments to an individual, Timothy Wood, for campaign sign storage.

## Takeaways

1. **The PAC donor list mirrors the district's own economic base.** TX-31 is built around Fort Cavazos, one of the largest U.S. Army installations, and the itemized PAC money reads accordingly: Lockheed Martin, General Dynamics, BAE Systems, Leonardo DRS, L3Harris, Textron, Boeing, and Honeywell together contributed roughly $92,500 — the largest identifiable donor bloc by industry, and a closer fit to the district's constituent economy than most incumbents' donor rolls achieve.

2. **A single specialty-medicine PAC gave as much as any defense contractor.** The American Society of Anesthesiologists PAC's $20,000 combined gift is unusual both in size and in being the only major non-defense industry interest to crack the top donor tier — worth watching against any health-care-payment legislation Carter takes up.

3. **The card-payment black box wasn't actually opaque — it just needed a different key.** This candidate's FEC exports don't use the back-reference field the analysis tool normally relies on to unpack lump card payments, so the existing detection method found nothing behind the $338,075.31 Chase total on the first pass. Pulling the raw memo-coded rows directly (now built into the tool, see Methodology) surfaced real spending on a private congressional club, restaurants, golf, and a consultant paid exclusively through card installments rather than direct checks — none of which would show up if a reader stopped at the top-level "Chase" line.

4. **Two same-address consultants split $89,000 in PAC "commission" payments.** Chrissie Miller and Jonas Miller, both listed in Round Rock, TX, were paid a combined $89,000 by the leadership PAC across three payments in under six months — a concentration of consulting fees on two apparently-related individuals that's worth independent confirmation of who they are and their relationship to the campaign.

5. **Personal finances reveal a concentrated stock position and a decades-old student loan.** Carter's 2025 Annual Financial Disclosure shows his largest asset by far is a single Edward Jones brokerage account (valued $1,000,001–$5,000,000, generating $50,001–$100,000 in dividend income) built around Exxon Mobil common stock — a notable single-issuer concentration for a sitting member of Congress. His other disclosed income comes from two Texas public pensions (Texas Judicial Retirement System and Texas County & District Retirement System), consistent with his pre-Congress career as a state district judge. On the liability side, alongside a mortgage refinanced with PNC Bank in 2024, he still lists a Mohela student loan dating to 1988 — a small, humanizing detail on an otherwise seven-figure balance sheet.

## Methodology & AI Transparency

**Model:** Claude Sonnet 5 (`claude-sonnet-5`), via Claude Code (VS Code extension). No user-configurable temperature or token-limit overrides were set for this session; the analysis ran under Claude Code's standard default sampling and context settings.

**Data-integrity notes specific to this run:**

- Both committee directories (`C00371203`, `C00427401`) were already correctly named by committee ID, avoiding the candidate-ID naming pitfall documented from a prior run.
- Checked for duplicate `transaction_id` values across all Schedule A/B files for both committees: none found. Schedule A's `amendment_indicator` for the campaign committee included 16 rows marked `C` ("CHANGE"); most of those are "Transfers from authorized committees" (a joint fundraising committee, Judge Carter Victory Fund, reallocating to participants) already excluded from donor totals by the tool's `DONOR_LABELS` filter, and the handful of genuine donor rows among them have unique, non-duplicated `transaction_id` values — consistent with the tool's documented assumption that FEC's processed exports already resolve amendments.
- **This run found and fixed a new gap in `analyze-candidate.rb`'s card-breakdown feature.** John Carter's committees never populate `back_reference_transaction_id` on Schedule B at all — every `memo_code=X` row has it blank — so the existing back-reference-based detection (added specifically to avoid the fragile text-matching that had undercounted Pfluger's and Casar's lump payments) found zero parent/child pairs here, even though 761 memo-coded rows carry real merchant-level detail (Facebook, Southwest Airlines, the Capitol Hill Club, H-E-B, and more) behind a $338,075.31 lump "Chase - Card Member Services" payment. The fix: every `memo_code=X` Schedule B row is now treated as itemized vendor detail regardless of whether a back-reference resolves, while `parent_total`/`coverage_pct` (which still depend on back-references) correctly report as $0/n/a here — an honest "can't verify against a known lump total," not a guess. Re-running the fixed tool against Pfluger's and Casar's existing data as a regression check picked up a small number of previously-missed memo rows lacking back-references in each (Pfluger: 1,812 → 1,817 sub-transactions, about $5,500 more; Casar: 37 → 39, about $275 more), with no change to either candidate's parent totals — a strict improvement, not a behavior change for already-validated candidates. Both the fix and this note are recorded in the tool's header comments per the standing instruction to document integrity fixes there rather than in a separate correction section here.
- `category_code_full` is blank for every disbursement row from the PAC (C00427401) — the same gap seen in Casar's data — so its $244,846.16 in spending shows up entirely under "Uncategorized" in the by-category table. `disbursement_description` text (e.g., "POLITICAL STRATEGY CONSULTING," "EVENT - VENUE RENTAL") was used directly where categorization mattered for Major Spending and Takeaways above.
- The single House Ethics Committee filing on record (Filing ID #10077379) is Carter's 2025 Annual Financial Disclosure, filed 2026-05-14, with no indication of an amendment — no Periodic-Transaction-Report double-counting risk applies to this filing, and Schedule B (transactions) reports "None disclosed."

**Prompt used (verbatim, template filled in):**

```
CANDIDATE: `John Carter`
DISTRICT: `TX-31`
```

Every `$CANDIDATE` / `$DISTRICT` below is that same substitution. `$CANDIDATE_DIR` is not filled in separately — derive it from $CANDIDATE and $DISTRICT using the convention already shown in "Process" above (lowercased district + kebab-case candidate name, e.g. `TX-11` + `August Pfluger` → `tx-11/august-pfluger`); if a close-but-not-exact match already exists under `tx-*/`, use that directory instead of creating a new one.

**Prompt history:** the pilot run of this prompt (TX-11/August-Pfluger) shipped a summary with a "Correction (post-publication review)" section — it took a second pass, prompted by a human asking pointed questions, to catch a couple of data-integrity bugs after the fact. Both are now fixed in [`/tooling/analyze-candidate.rb`](../../tooling/analyze-candidate.rb) and documented in its header comments, not repeated here — see the note below on why. This prompt (v2) tells the model to read and reuse that tool up front, specifically so a fresh session doesn't rediscover the same bugs before it can trust its own numbers. A "Correction" section in the output is a sign this prompt or the tool needs another pass, not an acceptable steady state.

**Tooling requirements:** Any tooling written to perform this analysis must be written in Ruby, using the version pinned in [`.ruby-version`](../../.ruby-version). Save all tooling artifacts (scripts, Rakefiles, etc.) to the `/tooling` directory. Gems should be managed normally with Bundler and a `Gemfile`, so the repo remains portable and reproducible for anyone with `rbenv` and `bundler` installed. **Before writing anything new, check whether [`/tooling/analyze-candidate.rb`](../../tooling/analyze-candidate.rb) already exists and covers this candidate's data** (`bundle exec ruby tooling/analyze-candidate.rb --help` shows its interface). It's built to be reused across candidates via `--fec-dir` / `--house-ethics-dir` arguments — extend it in place if a candidate's filings need something it doesn't handle yet, rather than writing a parallel one-off script. **Read that file's header comments in full before trusting or reporting any total** — they hold the specific, tested data-integrity gotchas (duplicate/amended filings, dropped correction rows, lump-sum vendor payments that look unitemized but aren't, and more) as close to the code they explain as possible, so they stay accurate as the tool changes instead of drifting out of sync with a second copy kept here.

**Analyze financial disclosure documents for $CANDIDATE ($DISTRICT) and create an executive summary.**

**Output:**
- Format: Markdown
- Filename: `$CANDIDATE_DIR/README.md`
- Length: Main analysis should be roughly 1,000-1,500 words. The complete Methodology & AI Transparency section (including the full verbatim prompt) doesn't count against this word limit.
- Title: `$DISTRICT: $CANDIDATE — Financial Disclosure Summary`

**Content sections (in this order):**

1. **Key Donors** — Top 5-10 individual/corporate donors by contribution amount. Include amounts and donor affiliation where relevant.

2. **Major Spending** — Top disbursements by category (e.g., staff, consulting, media, events). Highlight any unusual or notable expenditures.

3. **Takeaways** — 3-5 findings that are newsworthy, unexpected, or revealing about the candidate's priorities, funding sources, or spending patterns. Examples: unusual donor relationships, spending that contradicts public messaging, geographic patterns, or high-interest items like luxury dining or travel.

4. **Methodology & AI Transparency** — Disclose the LLM model name/version (e.g., Claude 3.5 Sonnet), key configuration settings (temperature, token limits), and the exact prompt used to generate this analysis (i.e. this template with $CANDIDATE/$DISTRICT filled in). This transparency allows readers to understand how findings were produced, assess potential model limitations or biases, and reproduce the analysis if desired. If applying `analyze-candidate.rb`'s data-integrity gotchas changed a finding versus a naive read of the data, say so briefly here instead of adding a separate correction section — this prompt already expects that check to happen before publication, not after.

**Tone:** Analytical, conversational for a general political audience. Avoid jargon; explain significance where needed.

**Source:** All data from FEC and House Ethics Committee disclosures in the `$CANDIDATE_DIR/` directory.
