# TX-11: August Pfluger — Financial Disclosure Summary

Rep. August Pfluger (R-TX11) raises money through three committees: his principal campaign committee, **August Pfluger for Congress** (C00719294); a joint fundraising committee, **Pfluger Victory Committee** (C00753913), which splits large checks among Pfluger's campaign and allied committees; and a mostly dormant leadership PAC, **PFriends of Pfluger** (C00840033). Across itemized FEC filings covering January 2025 through mid-2026, the three committees together raised **$4.24 million** and spent **$5.80 million** in itemized, non-memo transactions. The gap reflects a large campaign cash cushion carried into the cycle rather than a fundraising shortfall: the principal committee alone began the period with $2.32 million on hand and still ended it with $2.88 million, while the Victory Committee's cash grew from $64,727 to $293,100.

## Key Donors

Individuals account for about 75% of itemized money raised ($3.18 million); the remaining 25% ($1.06 million) comes from PACs and party committees. One contributor towers over the rest:

| Donor | Amount | Affiliation |
|---|---|---|
| Syed Javaid Anwar | $642,100 | President/CEO, Midland Energy Inc. (Midland, TX) |
| Cody Campbell | $50,000 | Co-CEO, Double Eagle Energy (Fort Worth, TX) |
| William Crump | $50,000 | Engineer, BC Operating Inc. (Midland, TX) |
| John Sellers | $25,000 | Co-CEO, Double Eagle Energy (Fort Worth, TX) |
| Tracy Sellers | $25,000 | Homemaker (Fort Worth, TX) |
| Scott A. Wisniewski | $25,000 | Owner, Western Shamrock Corp. (San Angelo, TX) |
| RCA Energy and Real Estate Properties, LP | $24,000 | Midland, TX |
| Kevin W. O'Neil | $22,000 | CEO, The O'Neil Group (Colorado Springs, CO) |
| Ross Perot Jr. | $22,000 | Dallas, TX |
| Dawn Jewell O'Neil | $22,000 | VP, One Funds (Colorado Springs, CO) |

Every one of these ten donations landed in the Pfluger Victory Committee, not the campaign committee directly — the joint fundraising vehicle's higher combined limits are what let a single donor like Anwar write checks totaling six figures across two contributions. Most of the biggest names cluster around Permian Basin oil and gas (Midland/Odessa/San Angelo), echoing the district's economic base.

## Major Spending

Of $5.80 million in itemized disbursements, net of vendor credits and refunds:

| Category | Amount | Share |
|---|---|---|
| Transfers (to campaign, NRCC, Raptor PAC, House Conservatives Fund) | $3,168,006 | 55% |
| Administrative/Salary/Overhead | $1,307,170 | 23% |
| Solicitation & Fundraising | $719,159 | 12% |
| Political Contributions (to other committees) | $219,500 | 4% |
| Advertising | $128,800 | 2% |
| Campaign Events | $75,111 | 1% |
| Travel | $64,573 | 1% |
| Everything else (materials, polling, donations, refunds) | $119,580 | 2% |

The "Transfers" line is the joint fundraising committee doing its job: routing pooled money to Pfluger's own campaign ($1.69 million), Raptor PAC ($720,323), and the House Conservatives Fund ($70,803), plus direct contributions to the NRCC ($863,351 combined across transfers and political contributions). The next-biggest single vendors are American Express ($652,300) and Citi ($169,791) — both are lump card payments, but that's not the dead end it might look like. FEC's own memo-item linkage breaks 120 such lump payments (mostly, but not only, the two card processors), totaling $973,867, down into 1,733 real, vendor-level sub-transactions totaling $908,713 — 93.3% of the lump total itemized at the merchant level. That layer shows $260,398 in travel (American Airlines alone: $71,541) and $332,714 in fundraising-related spend that includes a run of upscale-restaurant tabs: The Capital Grille ($34,006), Del Frisco's Double Eagle Steakhouse ($27,582), Oceanaire ($19,977), and Tosca ($11,197) — all in Washington, DC — plus the Capitol Hill Club ($12,850) and premium car services Savoya and BLS Limo Group ($24,272 combined). Notable one-off events booked outside the card system, both through the Victory Committee: **Stein Erikson Lodge**, a five-star ski resort in Park City, UT ($43,959, "facility rental and catering," August 2025), and **St. Joe Resort and Operations LLC** in Panama City Beach, FL ($37,819, "facility rental & catering," October 2025).

## Takeaways for Political Reporters

1. **One donor, $642,100.** Syed Javaid Anwar of Midland Energy is by far the single largest funding relationship in the dataset — roughly 15% of all itemized money raised — made possible entirely through the joint fundraising committee, which lets one donor's check exceed what any single participating committee could accept on its own.

2. **Pfluger's donors and his portfolio point the same direction.** The max-donor list is dominated by Permian Basin oil and gas executives (Double Eagle Energy, BC Operating, Midland Energy). A March 13, 2026 STOCK Act disclosure shows Pfluger personally purchasing $15,001–$50,000 stakes in four oil-and-gas-adjacent holdings — Dorchester Minerals, Kimbell Royalty Partners, Enterprise Products Partners, and Viper Energy — plus Berkshire Hathaway and Amerco (U-Haul), in the same window his committees were courting six-figure energy-sector checks.

3. **More than half of "spending" never touches a voter.** The $3.17 million "Transfers" category — 55% of all itemized disbursements — is money moving between Pfluger-aligned committees (his campaign, Raptor PAC, House Conservatives Fund, NRCC), not ads or field organizing. Anyone citing a "spending" total without separating this out will overstate direct campaign activity.

4. **Donor retreats at five-star properties.** The Victory Committee paid a Park City ski resort and a Florida Panhandle beach resort nearly $82,000 combined for "facility rental and catering" — a reminder that big-check fundraising often comes with a hospitality bill.

5. **The credit-card spending isn't actually a black box.** It would be easy to write off the $652,300 American Express and $169,791 Citi totals as opaque lump sums. But FEC filings link both to thousands of memo-coded sub-transactions with real merchant names, and reading those instead of stopping at the card-issuer line turns up a pattern of upscale Washington, DC dining charged to the campaign — The Capital Grille, Del Frisco's, Oceanaire, and Tosca, plus the Capitol Hill Club and two premium car services, around $80,000 combined — layered on top of $71,500 in American Airlines travel.

## Methodology & AI Transparency

This summary was produced by **Claude Sonnet 5** (model ID `claude-sonnet-5`), running as an agentic coding assistant inside the Claude Code VS Code extension. The session used the harness's default sampling configuration — no explicit temperature or max-output-token override was set by the operator, and those values are controlled by the Claude Code runtime rather than exposed to the model.

Analysis was tool-augmented, not a single prompt-to-text completion. Rather than writing new tooling, the model reused the existing, already-battle-tested [`/tooling/analyze-candidate.rb`](../../tooling/analyze-candidate.rb) (Ruby 3.3.8, dependencies managed via Bundler/`Gemfile`), invoked as:

```
bundle exec ruby analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --house-ethics-dir tx-11/august-pfluger/house-ethics
```

That script parses FEC Schedule A (itemized receipts) and Schedule B (itemized disbursements) CSVs for every committee directory it finds, excluding FEC memo-only entries from Schedule A (redundant conduit/earmark rollups) while preserving Schedule B memo rows separately as merchant-level detail behind lump card payments, netting negative correction rows (chargebacks, refunds) into running totals rather than discarding them, and restricting the donor view to `line_number_label`s that represent an actual outside contribution rather than inter-committee transfers or bank interest — see the strategy comments at the top of the script for the full rationale behind each of these choices.

Per this prompt's instruction to verify the tool's data-integrity gotchas against this candidate's specific data before trusting any total (not just assume they're moot because they're already coded), two checks were run by hand before writing this report:

- **Duplicate/amended `transaction_id` values.** Every FEC schedule file in this candidate's data has unique transaction IDs, with one exception: two `transaction_id`s in the Victory Committee's Schedule A each appear twice, as a memo/non-memo pair (one row `memo_code == "X"`, one not) rather than a competing amendment. The tool's donor-totals logic already excludes memo rows from Schedule A, so these are counted once, not twice — no fix was needed, but this is exactly the pattern the script's header warns a future candidate's data might not follow, so it's worth re-checking each time.
- **Naive vs. corrected reads of the two large "resort" payments** in the Takeaways above (Stein Erikson Lodge, St. Joe Resort/Panama City Beach) and the "black box" card-spending claim: both were spot-checked directly against the source CSVs (not just the tool's summary output) to confirm they're standalone, non-memo, in-scope payments and not double-counted card-memo children. They held up.

Neither check changed any figure or finding versus what the tool's summary output already showed — this candidate's data turned out clean on both fronts this time. That's a data point about this filing, not a guarantee for the next one; the header comments in `analyze-candidate.rb` document why both checks matter regardless of how any single candidate's data turns out. The House Ethics Committee PDF disclosures were mined via the script's text-extraction pass (the pure-Ruby `pdf-reader` gem, no external binaries), which is how the STOCK Act stock-purchase disclosure in Takeaway #2 was located, then verified by hand against the source PDF. The FEC cash-summary figures in the opening paragraph were read directly from the screenshots as images. Readers should independently verify any figure before republishing; FEC data is self-reported by campaigns and subject to amendment.

The exact instructions given to the model, verbatim, from this repository's root [`README.md`](../../README.md) under "Summary generation":

> CANDIDATE: `August Pfluger`
> DISTRICT: `TX-11`
>
> Every `$CANDIDATE` / `$DISTRICT` below is that same substitution. `$CANDIDATE_DIR` is not filled in separately — derive it from $CANDIDATE and $DISTRICT using the convention already shown in "Process" above (lowercased district + kebab-case candidate name, e.g. `TX-11` + `August Pfluger` → `tx-11/august-pfluger`); if a close-but-not-exact match already exists under `tx-*/`, use that directory instead of creating a new one.
>
> **Prompt history:** the pilot run of this prompt (TX-11/August-Pfluger) shipped a summary with a "Correction (post-publication review)" section — it took a second pass, prompted by a human asking pointed questions, to catch a couple of data-integrity bugs after the fact. Both are now fixed in [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) and documented in its header comments, not repeated here — see the note below on why. This prompt (v2) tells the model to read and reuse that tool up front, specifically so a fresh session doesn't rediscover the same bugs before it can trust its own numbers. A "Correction" section in the output is a sign this prompt or the tool needs another pass, not an acceptable steady state.
>
> **Tooling requirements:** Any tooling written to perform this analysis must be written in Ruby, using the version pinned in [`.ruby-version`](.ruby-version). Save all tooling artifacts (scripts, Rakefiles, etc.) to the `/tooling` directory. Gems should be managed normally with Bundler and a `Gemfile`, so the repo remains portable and reproducible for anyone with `rbenv` and `bundler` installed. **Before writing anything new, check whether [`/tooling/analyze-candidate.rb`](tooling/analyze-candidate.rb) already exists and covers this candidate's data** (`bundle exec ruby tooling/analyze-candidate.rb --help` shows its interface). It's built to be reused across candidates via `--fec-dir` / `--house-ethics-dir` arguments — extend it in place if a candidate's filings need something it doesn't handle yet, rather than writing a parallel one-off script. **Read that file's header comments in full before trusting or reporting any total** — they hold the specific, tested data-integrity gotchas (duplicate/amended filings, dropped correction rows, lump-sum vendor payments that look unitemized but aren't, and more) as close to the code they explain as possible, so they stay accurate as the tool changes instead of drifting out of sync with a second copy kept here.
>
> **Analyze financial disclosure documents for August Pfluger (TX-11) and create an executive summary.**
>
> **Output:**
> - Format: Markdown
> - Filename: `tx-11/august-pfluger/README.md`
> - Length: Roughly 1,000-1,500 words — a complete Methodology & AI Transparency section (including the full verbatim prompt) matters more than hitting the low end.
> - Title: `TX-11: August Pfluger — Financial Disclosure Summary`
>
> **Content sections (in this order):**
>
> 1. **Key Donors** — Top 5-10 individual/corporate donors by contribution amount. Include amounts and donor affiliation where relevant.
>
> 2. **Major Spending** — Top disbursements by category (e.g., staff, consulting, media, events). Highlight any unusual or notable expenditures.
>
> 3. **Takeaways for Political Reporters** — 3-5 findings that are newsworthy, unexpected, or revealing about the candidate's priorities, funding sources, or spending patterns. Examples: unusual donor relationships, spending that contradicts public messaging, geographic patterns, or high-interest items like luxury dining or travel.
>
> 4. **Methodology & AI Transparency** — Disclose the LLM model name/version (e.g., Claude 3.5 Sonnet), key configuration settings (temperature, token limits), and the exact prompt used to generate this analysis (i.e. this template with $CANDIDATE/$DISTRICT filled in). This transparency allows readers to understand how findings were produced, assess potential model limitations or biases, and reproduce the analysis if desired. If applying `analyze-candidate.rb`'s data-integrity gotchas changed a finding versus a naive read of the data, say so briefly here instead of adding a separate correction section — this prompt already expects that check to happen before publication, not after.
>
> **Tone:** Analytical, conversational for a general political audience. Avoid jargon; explain significance where needed.
>
> **Source:** All data from FEC and House Ethics Committee disclosures in the `tx-11/august-pfluger/` directory.
