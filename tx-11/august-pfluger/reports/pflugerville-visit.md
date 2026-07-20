# TX-11: The Pflugerville Stop — What August Pfluger's Newest Constituents Got, Versus His Donors

*A short companion piece to ["Campaign Spending as a Portrait of the Donor Class"](luxury-spending.md), following one specific thread: what does the filing data say about how August Pfluger has treated Pflugerville, one of the towns newly added to TX-11 by redistricting?*

## Why Pflugerville, specifically

TX-11 was redrawn for the 2026 cycle, and the new lines pulled in North Austin, Pflugerville, Round Rock, Cedar Park, and Leander — suburbs Pfluger never had to campaign in before, in exchange for dropping the sprawling, sparsely populated Big Bend region. Pflugerville is, in other words, not a place Pfluger chose to represent; redistricting handed it to him. That makes campaign spending there a useful test of how much attention a member of Congress pays to constituents he inherited versus the donor network he built himself over a full career in the Permian Basin.

So: does Pfluger's campaign paper trail show him showing up?

## The paper trail

Searching every FEC disbursement record collected for Pfluger's three committees for the word "Pflugerville" turns up exactly one campaign stop. On **2026-01-31**, during the Republican primary window, Pfluger's principal committee expensed a **$756.42** meal charge at **Springhill Restaurant**, 2505 W Pecan St, Pflugerville — filed as "MEAL EXPENSE" under the FEC's "Travel Expenses" category, tagged to the 2026 primary election:

- `tx-11/august-pfluger/fec/C00719294/schedule_b-2026-07-19T17_24_58.csv:1915`
- Also present in the raw, not-yet-fully-processed efile at `tx-11/august-pfluger/fec/C00719294/efile-2026-07-19T17_25_08.csv:127`

That's it. No hotel in Pflugerville, no venue rental, no printed event materials, no itemized contributions from Pflugerville donors in Schedule A around that date. One meal, one line item, ever, in the data collected for this candidate.

The surrounding week's charges — all itemized memo sub-items behind the same corporate Amex, all in the same late-January window — sketch out the actual trip:

| Date | Vendor | City | Amount | Citation |
|---|---|---|---|---|
| 2026-01-30 | Four Seasons Hotel | Austin, TX | $20.00 + $316.30 | `schedule_b:419`, `:1490` |
| 2026-01-31 | Shell (gas) | Brady, TX | $4.31 | `schedule_b:157` |
| 2026-01-31 | **Springhill Restaurant** | **Pflugerville, TX** | **$756.42** | `schedule_b:1915` |
| 2026-02-01 | Pinthouse Pizza | Round Rock, TX | $21.32 + $34.30 | `schedule_b:439`, `:662` |
| 2026-02-02 | JW Marriott | Austin, TX | $229.18 | `schedule_b:1279` |

Brady, TX sits almost exactly on US-87 between San Angelo — where the campaign is headquartered — and Austin. A $4.31 gas-station charge there isn't a fill-up; it's the kind of top-off charge you get from someone driving through, not flying. Read together, this looks like a drive up from San Angelo through Central Texas, a night in Austin, a stop at Springhill in Pflugerville, a stop in Round Rock the next day, and a return trip through Austin again — not a dedicated Pflugerville event, but a brief pass through the newest part of the district on the way to somewhere else. The whole swing — hotels, gas, and meals combined, Pflugerville included — comes to **$1,381.83**.

## What kind of place is Springhill

Springhill Restaurant has operated in Pflugerville since 1985. It's a Southern comfort-food buffet whose whole identity is built around fried catfish — its own website is literally `springhillcatfish.net`. The menu runs $14.99 for a dinner salad with catfish, with a family pack of 20 fried fillets for a group. A $756.42 tab there is a big group order, not a five-course tasting menu — the kind of check that comes from a table of a few dozen people working through a catfish buffet, not a private dining room.

Contrast that with where the same campaign's money went in the same general window and the ones documented at length in the companion report: **The Capital Grille** ($49,430.75 across 69 visits), **Del Frisco's Double Eagle Steakhouse** (a single $27,582.00 charge), **Stein Eriksen Lodge** at Deer Valley ($43,959.03 in one "facility rental and catering" line), and **Baltusrol Golf Club**, the $150,000-initiation private course in New Jersey ($16,988.10). Any one of those single line items dwarfs the entire Central Texas swing that included the Pflugerville stop — Stein Eriksen Lodge alone is **32 times** the whole trip's cost.

## The math, plainly

- **One Pflugerville meal, ever, in the data:** $756.42
- **Whole Central Texas swing that included it:** $1,381.83
- **A single dinner's worth of Capital Grille charges, one committee, one week:** frequently $1,000–$3,500 (see the companion report for specific dates)
- **One night's charge at Stein Eriksen Lodge:** $43,959.03 — 58x the Pflugerville meal, 32x the whole swing
- **Total identified "fine dining, retreats, gifts, and luxury transport" spending across the same committees:** roughly $678,000 (see [luxury-spending.md](luxury-spending.md))

Put another way: the single Stein Eriksen Lodge charge alone cost **58 times** what the entire Pflugerville stop did.

## What this actually says

This is one data point, and it would be overclaiming to say a single restaurant receipt proves a member of Congress "doesn't care" about a town — a filing record only shows what got itemized on a campaign card, not every phone call, staff visit, or robocall a district received. But as far as the paper trail goes: in the months of data collected here, Pfluger's committees show one identifiable stop in Pflugerville, worth three-quarters of one steakhouse dinner, against a documented pattern of five- and six-figure spending at ski lodges, private golf clubs, and downtown DC steakhouses for the donor class that funds the campaign. Redistricting added a strip of North Austin, most of Pflugerville, and parts of Round Rock, Cedar Park, and Leander to TX-11 — voters who didn't choose this representative, and who on this evidence haven't yet seen the campaign's money follow them.

---

# Methodology & AI Transparency Appendix

*(As with the companion report, this section is not subject to any length constraint on the body above.)*

**Report generated:** 2026-07-20T00:31:41Z (2026-07-19, 7:31 PM Central Daylight Time), by Claude Sonnet 5 (Anthropic), running as the "Claude Code" CLI agent inside a VS Code extension session, on behalf of user Tod Beardsley.

**How this report came about:** this was a follow-up to [luxury-spending.md](luxury-spending.md), prompted by the user recalling (from outside this repository — personal knowledge, not derived from the data) that Pfluger visited Pflugerville once during the primary, and asking whether that showed up in the filings. A search for "Pflugerville" across every collected FEC file for this candidate found the single Springhill Restaurant charge described above. The user then asked, semi-jokingly, how Pfluger got to and from Pflugerville, since no transportation charge was itemized to Pflugerville itself — which led to identifying the surrounding week's Austin/Brady/Round Rock charges on the same card as circumstantial evidence of a driving route, rather than a mystery. The user then asked for this thread to be written up as its own report, explicitly framing it around the contrast with the donor-class spending in the companion report, and asked that their own framing be quoted directly below.

**Data sources:** the same collected FEC Schedule B (disbursements) files used in the companion report — `tx-11/august-pfluger/fec/C00719294/schedule_b-2026-07-19T17_24_58.csv` and the corresponding raw `efile-2026-07-19T17_25_08.csv` for the one charge that postdates the processed export's coverage. No new data was downloaded for this report. Schedule A (receipts) for the same committee was also checked for Pflugerville-area contributors around the relevant dates and found empty — noted above as evidence this wasn't a fundraiser.

**Tooling used:** none of the repository's Ruby tooling was a good fit for a single-keyword, single-date-range lookup like this, so it was done with ad hoc `grep`/`awk` commands directly against the already-collected CSVs (e.g. `grep -i "pflugerville" tx-11/august-pfluger/fec/*/schedule_*.csv`, and an `awk` date-range filter over `schedule_b` for 2026-01-28 through 2026-02-03). This is the same judgment call the companion report's methodology section described for its own one-off rollups: a throwaway lookup like this isn't reusable analysis, so it wasn't written to `/tooling` as a new script. If a future report needs this kind of "everything near date X and place Y" query repeatedly, that would be a reasonable candidate for a small addition to `tooling/vendor-keyword-scan.rb` (e.g. a `--near-date`/`--city` filter) rather than a one-off.

**Verification performed:** all five citations above were checked against the source CSV directly (`sed -n '<line>p' <file>` and manual column inspection) before publication. The characterization of Springhill Restaurant (cuisine, price point, since-1985 operation) was checked via one web search against the restaurant's own site and menu listings, cited inline in the "What kind of place is Springhill" section.

**Web research:** one search — "Springhill Restaurant Pflugerville Texas menu catfish" — confirmed the restaurant's identity as a catfish-focused Southern buffet (its own domain is `springhillcatfish.net`) operating since 1985, with menu pricing around $14.99 for a catfish dinner salad.

**Interpretive framing — direct quote from the user, Tod Beardsley, who requested it be included here verbatim:**

> "This representative's campaign spends many, many thousands of dollars on steak and golf courting donors, while leaving his new constituents with fried catfish. Pfluger clearly doesn't much care for Pflugerville."

This is the user's characterization, not an independently verified finding — the "What this actually says" section above states plainly what the data can and can't support on its own (one itemized stop, not proof of indifference). It's included here, attributed, at the user's explicit request, rather than folded into the report's own analytical voice.

**Limitations:**

- This is a single data point built from one keyword search. It cannot rule out unitemized outreach (calls, mail, district staff visits that don't route through a campaign committee's disbursement filings) and should not be read as a complete account of Pfluger's engagement with Pflugerville.
- The Brady/Austin/Round Rock route is circumstantial reconstruction from nearby-dated card charges, not a confirmed itinerary — no single record states "this is August Pfluger's driving route." It's a plausible reading of the data, clearly labeled as such above, not a certainty.
- As with the companion report, all of these charges are on a shared campaign card; the data cannot distinguish which staff member(s) traveled versus the candidate himself.
