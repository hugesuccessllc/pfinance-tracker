# TX-17: Casey Shepard — Financial Disclosure Summary (2026 Cycle)

Casey Shepard is a Waco attorney who ran in the 2026 Democratic primary for Texas' 17th Congressional District, finished among the top two in the March 3 first round, and won the May 26 runoff against Jamilah Flores. Shepard now heads into a November 3 general election against Republican incumbent Pete Sessions. The financial picture on file with the FEC so far is tiny and almost entirely self-funded: **$1,300.00** in qualifying outside contributions from three individual donors, against **$5,302.27** the candidate put in personally — most of it a single $5,000 loan. There is exactly one committee to look at, **Casey Shepard for Congress** (C00934547), and no PAC or party money shows up anywhere in the file. A House Ethics Committee financial disclosure, filed separately, fills in the rest of the picture: Shepard works as a McLennan County appointed criminal defense attorney and holds a handful of small retirement investments.

## Key Donors

Every qualifying donor this cycle is an individual; no PAC, corporate, or committee money appears in the data at all.

| Donor | Amount | Location | Employer / Occupation |
|---|---|---|---|
| Peter Kultgen | $1,000.00 | Waco, TX | Retired |
| Kristen Young | $200.00 | Leander, TX | Nurse Practitioner, Austin Gastro |
| Bruce Allen | $100.00 | Woodway, TX | Retired |

That's the entire outside-donor list — three names, $1,300.00 combined. Kultgen's and Allen's Waco-area/Woodway addresses track the district (Waco is TX-17's population center), but Young's Leander donation is a geographic outlier: Leander sits in Williamson County, well outside TX-17's boundaries, closer to TX-31 or TX-10 territory. It's a small, unremarkable individual contribution, but worth flagging as the one donor whose location doesn't fit the district.

Separate from this table, the campaign also logged **$302.27** in small contributions and a **$5,000.00** loan directly from Casey Shepard — both excluded from "Key Donors" here because they're the candidate's own money, not outside support, but they're the largest single financial facts in the file (see Takeaways below). Combined with the $1,300.00 above, total money into the committee this cycle is **$6,602.27**.

## Major Spending

Total itemized disbursements for the cycle: **$4,984.86**, broken out by FEC category:

| Category | Amount | Items |
|---|---|---|
| Advertising | $4,785.94 | 23 |
| Uncategorized | $189.46 | 8 |
| Travel | $9.46 | 1 |

Only three payees appear in the entire disbursement file:

1. **American Printing and Mailing** (Austin, TX) — **$3,318.36**, all print-media flyers and mailers. The largest single charges were $1,939.52 and $408.49 (twice), both booked February 20, 2026.
2. **Meta Platforms** (Menlo Park, CA) — **$1,548.58**, entirely Facebook advertising, spread across roughly two dozen small charges (mostly $40–$215 each) from early February through mid-March.
3. **Casey Shepard** (the candidate) — **$117.92**, a mix of a $9.46 travel-expense reimbursement and several small in-kind reimbursements (Facebook ads and website services the candidate paid for personally, then booked as in-kind contributions matched by an equal in-kind disbursement — these net to zero actual cash movement, which is why they show up as "Uncategorized" rather than Advertising).

In short: this is a two-vendor campaign. American Printing and Mailing and Meta Platforms together account for **$4,866.94** — 97.6% of every dollar spent — split between paper flyers mailed locally and Facebook ads. There's no consulting, polling, staff payroll, or events spending of any kind in the file.

## Takeaways

1. **This is a self-funded shoestring campaign, not a donor-driven one.** Casey Shepard personally put in $5,302.27 (a $5,000 loan plus $302.27 in small direct contributions) — more than four times the $1,300.00 raised from three outside donors combined. For a candidate who just won a competitive primary runoff, that's a striking imbalance toward self-funding over grassroots support, at least in what's captured here.

2. **No PAC, party, or committee money anywhere in the file.** Every qualifying dollar came from named individuals — no EMILY's List, no state party, no ideological PAC, nothing. That could reflect the primary-runoff stage this data covers (before the DCCC or allied groups typically engage) more than a considered fundraising strategy, but as of this filing, Shepard's campaign is being bankrolled almost entirely by the candidate and three individual well-wishers.

3. **The entire ad budget ran through just two vendors: a local Austin print shop and Facebook.** $3,318.36 to American Printing and Mailing and $1,548.58 to Meta Platforms account for essentially all spending. There's no sign yet of the paid-media infrastructure (media buyers, pollsters, direct-mail consultants) a general-election campaign against a sitting incumbent typically builds out.

4. **This data almost certainly predates the general-election ramp-up.** The processed FEC exports run through May 21, 2026 (receipts) and March 19, 2026 (disbursements) — the runoff Shepard won was May 26, 2026, five days after the receipts data even ends. A second-quarter raw filing (covering through June 30, 2026) is already sitting in this committee's folder but adds no new itemized transactions beyond what's above, meaning the file shows essentially nothing from the weeks immediately after the runoff win, and nothing at all from the summer campaign for the November 3 general. See Methodology below for what that means for how current these numbers are.

5. **The candidate's own House Ethics disclosure explains where the $5,000 loan likely came from.** Shepard's annual Financial Disclosure Statement (filed 02/18/2026, covering 01/01/2025–01/02/2026) reports $5,500 in earned income from McLennan County as an appointed criminal defense attorney, plus four small ETrade 401(k) holdings (covered-call ETFs on the Dow, NASDAQ 100, Russell 2000, and S&P 500) worth a combined $1,800. No liabilities, outside positions, or agreements are disclosed. That's a modest, working-attorney financial profile — not a wealthy self-funder — which makes the $5,000 personal loan a meaningfully larger commitment relative to the candidate's own disclosed assets than it might otherwise read.

6. **One donor's location doesn't match the district.** Kristen Young's $200 contribution lists a Leander, TX address — outside TX-17 entirely. It's a minor, plausible detail (an out-of-district friend or former colleague giving a small amount) rather than a red flag, but it's the only donor in the file who isn't local to the Waco-area district Shepard is running in.

## Suggested Committees for Further Investigation

None. `Casey Shepard for Congress` (C00934547) is the only committee collected, and nothing in its Schedule A or Schedule B data references any other committee — no joint fundraising committee, no leadership PAC, no transfer-recipient rows of any kind. This reads as a genuinely single-committee operation at this stage of the race; there's nothing visible in the already-collected data pointing toward a second committee worth pursuing.

## Methodology & AI Transparency

- **Model:** Claude Sonnet 5 (`claude-sonnet-5`), running in Claude Code (VS Code extension). Temperature and token-limit settings are the Claude Code harness defaults; they are not user-configured or exposed per-request in this environment.
- **Committee analyzed:** C00934547 — Casey Shepard for Congress (principal, itemized, 2026 cycle only). No other committee directories exist under `tx-17/casey-shepard/fec/`.
- **Command run:**
  ```bash
  ruby tooling/analyze-candidate.rb \
    --fec-dir tx-17/casey-shepard/fec \
    --house-ethics-dir tx-17/casey-shepard/house-ethics \
    --cycle 2026
  ```
- **Data provenance:** `fec/C00934547/` carries `.download-progress` and `.efile-progress` marker files and a `PRINCIPAL` marker, indicating it was collected via `fec-api-client.rb --download` rather than manually exported, with the itemized schedule_a/schedule_b files timestamped 2026-09-03. The House Ethics PDF (`10073306.pdf`) carries no such markers and was collected manually.
- **EFILE COVERAGE WARNING:** not triggered on this run. The committee's raw `efile-*.csv` files do contain itemized Schedule A/B rows extending into a period nominally covered by a July 31, 2026 quarterly filing, but every one of those rows is dated at or before the processed exports' own ceiling dates (schedule_a through 2026-05-21, schedule_b through 2026-03-19) — spot-checked directly against the raw efile CSVs — so none of them fall in the "genuinely new territory" window the tool's gap-filling logic looks for, and none were added to the totals above.
- **Data-integrity checks that shaped the findings** (per the gotchas documented in `tooling/analyze-candidate.rb`'s header): the $5,000.00 "Loans Received from the Candidate" line and $302.27 in "Contributions From the Candidate" rows are both excluded from the qualifying-donor totals and the Key Donors table by design (DONOR_LABELS only counts contributions from individuals/persons and other political committees) — reported separately above because, for a campaign this small, the candidate's own money is the single largest fact in the file, not a footnote.
- **House Ethics filing:** the collected PDF (Filing #10073306, filed 02/18/2026) is an annual Financial Disclosure Statement covering 01/01/2025–01/02/2026 — not a Periodic Transaction Report. It reports one earned-income source (McLennan County, $5,500, appointed criminal defense work — also itemized separately in the filing's compensation-over-$5,000 section), four small ETrade 401(k) asset lines (combined value $1,800), and no liabilities, positions, or agreements. This is Shepard's only House Ethics filing collected here; per this repository's standing note that House Ethics filings are legally required, that likely reflects the candidate having filed only this one so far in the race rather than a collection gap, but that hasn't been independently confirmed against the Clerk's site.
- **Source:** FEC disclosures in `tx-17/casey-shepard/fec/`, filtered to the 2026 cycle, plus the House Ethics Committee disclosure in `tx-17/casey-shepard/house-ethics/`.
- **Note on this run:** this report reflects a House Ethics Committee filing added to `tx-17/casey-shepard/house-ethics/` since this candidate was last analyzed; the underlying FEC data is unchanged.
- **Exact prompt used** (v8 template with `$CANDIDATE`/`$DISTRICT`/`$CYCLE` filled in — see the top-level [README.md](../../README.md) for the full template text and its version history):

<details>
<summary>Full verbatim prompt</summary>

````text
CANDIDATE: `Casey Shepard`
DISTRICT: `TX-17`
CYCLE: `2026`
````

</details>
