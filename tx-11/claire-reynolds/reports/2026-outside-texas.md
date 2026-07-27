# TX-11: Claire Reynolds — Out-of-State Money in the 2026 Receipts

*What share of Claire Reynolds's 2026-cycle donor receipts — by dollar value AND by raw contribution count — comes from outside Texas, and who's behind it.*

## The short version

Of the **$65,455.74** in itemized donor receipts recorded for Claire Reynolds's single 2026-cycle committee (Claire Reynolds for Congress, C00929711 — there is no JFC or leadership PAC in this campaign's data), **$23,655.08 — 36.1% of the money — came from outside Texas**, from **39 of the campaign's 103 contributions — 37.9%**.

Unlike this project's companion report on August Pfluger's committees (`tx-11/august-pfluger/reports/outside-texas.md`), where the dollar share (33.2%) and contribution-count share (84.2%) of out-of-state money diverged sharply, Reynolds's two percentages sit close together — 36.1% and 37.9%. That similarity is itself informative: it means there's no large population of small, repeat, out-of-state micro-donations padding the count without moving the total, the pattern that drove Pfluger's gap. Every donor in this dataset gives once, twice, or at most three times all cycle.

## Where the out-of-state money comes from

| State | Amount | Contributions |
|---|---|---|
| TX | $41,800.66 | 64 |
| CA | $12,700.08 | 17 |
| DC | $5,000.00 | 1 |
| MO | $1,200.00 | 3 |
| NY | $1,000.00 | 2 |
| OH | $1,000.00 | 2 |
| FL | $755.00 | 3 |
| NJ | $500.00 | 1 |
| IL | $500.00 | 1 |
| PA | $450.00 | 3 |
| MA | $400.00 | 3 |
| MN | $100.00 | 1 |
| LA | $25.00 | 1 |
| WA | $25.00 | 1 |

California alone — $12,700.08 across 17 contributions — is more than half of all out-of-state money, and almost all of it traces to one metro area: **San Diego.** Donors in San Diego proper, plus adjacent Oceanside and Poway, account for **$11,950.00 across 15 contributions** — **50.5% of every out-of-state dollar** in this campaign, from **38.5% of every out-of-state contribution**. The cluster includes Richard Toscano (financial advisor, $3,000 across two checks), Ros Nesler of Oceanside ($3,500 across three checks, occupation "Not employed"), Christina Mannion (an architect employed by SDUSD — San Diego Unified School District, $1,000), Robert Fellmeth of Poway ($1,000), Brett Humphrey (CEO of Mivien Inc., $1,000), Jessica Heldman (a University of San Diego professor, $1,000 across two checks), Kelly Lewis (a County of San Diego public health nurse, $500), plus smaller checks from a Lexis Nexis IT director, a mediator, and a marketing director, all in San Diego. A handful of other California donors — San Carlos (Bay Area, not the San Diego neighborhood of the same name — this is the San Mateo County city, per its zip code 94070), Oakland, and Palm Springs — round out the state total but sit outside this cluster.

Nothing else outside Texas comes close to that concentration. **Vote Save America** ($5,000, Washington, DC) is the only PAC or committee donor of the entire cycle — a national progressive digital-fundraising vehicle tied to the Crooked Media podcast network (Pod Save America), not an industry or issue-advocacy PAC, as `README.md`'s own Key Donors analysis already notes. And **Olen Reynolds** of Kirkwood, Missouri ($1,200 across three gifts) shares the candidate's surname — almost certainly a family member giving in modest, recurring amounts, the same kind of ordinary, disclosed household-adjacent activity this project's `README.md` already flags for a Beardsley-surnamed disbursement elsewhere in this committee's spending data.

## Retirees versus working people

Restricting to individual donors (excluding Vote Save America, the one PAC), and sorting by the FEC's own free-text `contributor_occupation` field: very few of Reynolds's donors are explicitly retired. Only **2 of 102** individual contribution rows this cycle literally list the occupation "RETIRED." A much larger group — **34 rows** — lists "NOT EMPLOYED," which, per this project's own established caveat (see `README.md`), FEC filers use for genuine retirees about as often as for the actually unemployed, so the two categories are combined below as "not employed / retired" rather than treated as separately meaningful.

| | Employed | Not employed / retired |
|---|---|---|
| **Texas** | $27,846.66 (66.6%) — 38 contributions (59.4%) | $13,954.00 (33.4%) — 26 contributions (40.6%) |
| **Out-of-state** | $11,580.08 (62.1%) — 26 contributions (68.4%) | $7,075.00 (37.9%) — 12 contributions (31.6%) |

Two things stand out, both a contrast with the Pfluger companion report. First, working professionals — not retirees — dominate on both sides of the state line, and out-of-state donors skew *more* employed than in-state ones (68.4% of out-of-state contributions vs. 59.4% of Texas ones). Second, and more fundamentally: nobody in this dataset repeats the way Pfluger's out-of-state retiree donors did. The most any single Reynolds donor gives is three times all cycle (Olen Reynolds, Elizabeth Haley, Caitlin Condon); Pfluger's committees, by contrast, included out-of-state retirees itemized well over a hundred times each. Reynolds's out-of-state money looks like it comes from a personal and professional network making one-off or occasional contributions — academics, healthcare workers, attorneys, engineers — not a list-based small-dollar donor-processing operation.

## Takeaways

1. **The dollar share and the count share of out-of-state money are close together (36.1% vs. 37.9%) because there's no high-frequency small-dollar donor base inflating the count.** That's a structurally different picture from Pfluger's committees, where the same two numbers were 33.2% and 84.2% — a nearly 51-point gap driven by thousands of small, repeat, out-of-state retiree contributions this campaign simply doesn't have.
2. **Half of all out-of-state money comes from one place: greater San Diego.** $11,950 of the campaign's $23,655.08 in out-of-state receipts — better than half — traces to San Diego, Oceanside, and Poway, a tighter geographic concentration than any other slice of this dataset. The mix of employers (a school district, a county health department, a private university, small local firms) suggests a personal or professional network rather than a national donor list; what that network is isn't established by this data and would need a human's own follow-up.
3. **The only PAC contribution of the cycle is also the only Washington-based one** — Vote Save America's $5,000, a national digital-fundraising vehicle, not an industry group. Even the one exception to this campaign's "no PAC, no industry money" story is itself a national small-dollar-adjacent operation, not a lobbying interest.
4. **Working professionals, not retirees, fund this campaign from outside Texas** — the mirror image of the Pfluger finding. Where Pfluger's out-of-state individual contribution rows were 88.1% retiree-labeled, Reynolds's out-of-state donors actually skew slightly *more* employed than her Texas donors do.
5. **A likely family contribution is present and unremarkable.** Olen Reynolds's $1,200 across three small checks from Missouri is exactly the kind of household-adjacent giving this project's `README.md` already treats as normal, disclosed activity rather than a flag.

## Caveats

This is a small dataset — 103 total contributions, only 39 from outside Texas — so every percentage above is more sensitive to a single check than a larger campaign's would be; the one $5,000 Vote Save America contribution alone is over a fifth of all out-of-state money. Donor scoping follows this project's standard rule: only rows FEC labels "Contributions From Individuals/Persons Other Than Political Committees" or "Contributions From Other Political Committees" count, memo rollup rows are excluded, and — because more than half of this cycle's receipts weren't yet in FEC's processed export at analysis time — the campaign's raw efile submissions were folded in for the gap window only (see Methodology). "Out-of-state" reflects the `contributor_state` field exactly as filed, not necessarily a donor's current residence. The San Diego "cluster" and the Olen Reynolds "likely family member" characterizations are both observed patterns in the filed data, not confirmed relationships — flagged here as leads, not established facts. As with every report in this project: a legal, fully disclosed contribution is not evidence of anything improper; this report counts and traces the money and leaves judgment about what it means to the reader.

---

# Methodology & AI Transparency Appendix

*(This section is excluded from the report's word-count consideration, per this project's standing convention.)*

**Report generated:** 2026-07-27, by Claude Sonnet 5 (Anthropic), running as the "Claude Code" CLI agent inside a VS Code extension session, on behalf of user Tod Beardsley. Default Claude Code agent settings for this session; no unusual temperature/token-limit configuration was requested or applied.

**Data sources:** FEC Schedule A (receipts) export for Claire Reynolds's single 2026-cycle committee, stored under `tx-11/claire-reynolds/fec/C00929711/`, plus its raw `efile-*.csv` receipts, restricted to rows dated after the processed `schedule_a` export's own latest date. As `README.md` already documents, this gap is unusually large for this candidate: processed data ends 2026-03-31, but efile data extends through 2026-06-30, adding 64 of this report's 103 contributions ($34,604.04) — more than half the cycle's money. Report scoped strictly to the 2026 two-year FEC cycle (`two_year_transaction_period` = 2026).

**Tooling:** `tooling/analyze-candidate.rb --by-state` (built in this project's prior session for the companion Pfluger report; no changes needed here) produced the grand total, the Texas/out-of-state $ and n splits, the per-state table, and the top out-of-state donor list. Command run:
```
ruby tooling/analyze-candidate.rb --fec-dir tx-11/claire-reynolds/fec --cycle 2026 --by-state --top 40 --format json --out /tmp/reynolds-geo.json
```
This reproduces the same $65,455.74 total and per-quarter efile-gap figures already reported in `README.md`, confirming this report's data lines up with the existing analysis rather than diverging from it.

**San Diego cluster and employed/retired breakdown:** neither is native output of `analyze-candidate.rb --by-state` (which reports totals by state, not by city, and doesn't classify donors by employment status), so two short single-use Ruby scripts (not saved to `/tooling`) required `FecAnalyzer` as a library and reused its private `load_rows`, `cycle_matches?`, `decimal`, and `efile_gap_rows` methods via `send`, exactly as this project's Pfluger report did for its per-committee split — this avoids re-deriving the `DONOR_LABELS`/memo/efile-gap scoping logic and risking it drifting from the tool's own tested behavior. The San Diego-cluster city/zip grouping and the employed/not-employed bucketing (occupation field containing "NOT EMPLOYED," "RETIRED," "N/A," "NONE," or blank vs. everything else) were both applied to the same row set this produced.

**Verification performed:** every dollar figure, contribution count, and named-donor detail above was checked directly against the source CSVs (`fec/C00929711/schedule_a-2026-07-20T08_23_11.csv` and `fec/C00929711/efile-2026-07-20T08_23_19.csv`) before publication, including confirming San Carlos, CA's zip code (94070, San Mateo County) to avoid mistakenly folding it into the San Diego cluster — an easy mistake given the name, and one this report specifically checked for and excluded.

**Web research:** none conducted for this report. Every named donor and employer above is described using only the free-text fields the campaign itself filed with the FEC — no outside identity verification was attempted, consistent with the Caveats section above.

**Verbatim prompt this report was generated from:**

> CANDIDATE: `Claire Reynolds`
> DISTRICT: `TX-11`
> CYCLE: `2026`
>
> Give tx-11/claire-reynolds the same treatment. Same prompt as the Pfluger investigation, but with Claire Reynolds. Name the report tx-11/claire-reynolds/reports/2026-outside-texas.md

> [mid-session follow-up] Be sure to note retirees versus working people.

**Limitations and things a human should double-check before citing this report further:**

- Single-cycle (2026) snapshot of a small, early-stage campaign; percentages here are far more sensitive to individual contributions than a larger operation's would be, and shouldn't be read as a stable long-term pattern.
- "Out-of-state" is a filing-address question, not a "connection to the district or candidate" question.
- The San Diego cluster and the Olen Reynolds family-connection read are both pattern observations from the filed data, not independently confirmed relationships.
- No claim is made that any contribution here violates a contribution limit or FEC rule; this report does not attempt to check that.
