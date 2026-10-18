# TX-11: August Pfluger — Refunded Contributions in the 2026 Cycle

*Every donor August Pfluger's 2026-cycle committees refund money to, split between those whose refund lines up with a per-election contribution limit and those refunded for some other reason.*

## The short version

Pfluger's four 2026-cycle committees are:
- **August Pfluger for Congress** (C00719294), the principal campaign committee;
- **Pfluger Victory Fund** (C00753913), a joint fundraising committee (JFC);
- **Raptor PAC** (C00749481), his leadership PAC;
- **Pfriends of Pfluger** (C00840033), a second, much smaller joint fundraising committee.

Through Sept. 30, 2026, these committees refund **29 donors a combined $53,994.78**. They fall into three groups:

| Group | Donors | Refunded | Share |
|---|---:|---:|---:|
| Likely hit a contribution limit | 6 | $22,999.25 | 42.6% |
| Business-entity checks returned in full | 8 | $23,250.00 | 43.1% |
| Refunded for other reasons | 15 | $7,745.53 | 14.3% |

- **The cap cases** show the signature of a per-election contribution-limit problem: a running total that reached or passed the legal ceiling just before the refund, and a refund that trims the excess.
- **The business-entity refunds** are the cycle's most striking pattern. The joint fundraising committee returns, in full, checks written in the name of LLCs, professional practices and a farm, mostly from Odessa and Midland. Seven of them come back within a month of arriving, in a single September batch.
- **The remaining refunds** look nothing like a cap trim. Most are full or near-full refunds of small, often recurring online gifts from retirees: the pattern of reversed charges or donor requests, not a campaign paring someone down to a legal maximum.

## Likely hit the per-election contribution limit

**Safari Club International PAC (SCI-PAC), San Antonio: $5,000.00 refunded by the principal committee on 2026-07-02.** This is the clearest cap case in the dataset.
- SCI-PAC gives the Pfluger Victory Fund two $5,000.00 checks six days apart, on 2026-04-22 and 2026-04-28 (`fec/C00753913/schedule_a-2026-10-18T10_28_44.csv:2426`, `:2388`).
- Both pass through to the campaign, designated for the 2026 general election, pushing SCI-PAC's running total for that election to **$10,000.00**. That's twice the $5,000 per-election limit for a multicandidate PAC (`fec/C00719294/schedule_a-2026-10-18T10_20_55.csv:25879`, `:25669`).
- The second attribution row carries the committee's own note, "SEE REFUND ON 7/2/2026," and exactly $5,000.00 comes back on that date (`fec/C00719294/efile-2026-10-18T10_21_47.csv:162`).

**Lawrence Wiley, Fitchburg, Wis. (attorney, Epic): $3,500.00 refunded by the principal committee on 2026-09-21.**
- Wiley gives two $3,500.00 contributions on 2026-07-15, both designated for the 2026 general election. That's a $7,000 running total against the $3,500 individual per-election limit (`fec/C00719294/efile-2026-10-18T10_21_08.csv:2376`, `:2378`).
- The excess, $3,500.00, comes back two months later (`efile-2026-10-18T10_21_47.csv:163`).

**Richard DeBoer, Appleton, Wis. (retired): $3,499.25 refunded by the principal committee on 2026-08-20.**
- DeBoer gives three general-election contributions on 2026-06-22: $3,500.00, $3,499.25 and $10.75, a $7,010.75 running total (`fec/C00719294/schedule_a-2026-10-18T10_20_55.csv:23491`, `:23493`, `:23495`).
- The committee notes the $3,499.25 row as "PENDING SPOUSAL REATTRIBUTION OR SEE REFUND." In other words, it could be reassigned to a spouse's limit or returned. It's refunded (`efile-2026-10-18T10_21_47.csv:185`).
- The $10.75 row is marked "SEE REFUND ON 7/8/2026," but no matching refund appears in the data. If it was refunded, DeBoer ends exactly at the limit.

**E-PAC, Glens Falls, N.Y.: $5,000.00 refunded by Pfriends of Pfluger on 2025-08-07.**
- E-PAC is the leadership PAC of Rep. Elise Stefanik (R-N.Y.), also known as Elevate PAC. It writes Pfriends of Pfluger a single $5,000.00 check on 2025-07-14, which brings its running total for that committee to exactly $5,000.00, the multicandidate-PAC per-election limit (`fec/C00840033/schedule_a-2026-10-18T10_33_17.csv:48`).
- The full $5,000.00 comes back three weeks later (`fec/C00840033/schedule_b-2026-10-18T10_33_38.csv:56`). The check *reaches* the ceiling rather than exceeding it, so the cap reading is plausible but not airtight.
- This $5,000 in and $5,000 out is the entirety of Pfriends of Pfluger's 2026-cycle activity.

**American Petroleum Institute PAC (API PAC), Washington: $3,500.00 refunded by the principal committee on 2026-02-02** (`fec/C00719294/schedule_b-2026-10-18T10_21_28.csv:8758`).
- API PAC writes the Pfluger Victory Fund four checks in the 2026 cycle, totaling $8,500.00 (`C00753913/schedule_a:2910`, `:2831`, `:2564`, `:2513`):
  - $2,500.00 on 2025-06-09
  - $1,000.00 on 2025-08-01
  - $1,500.00 on 2026-02-09
  - $3,500.00 on 2026-03-03
- By August 2025, the first two checks put $3,500.00 against the campaign's primary limit (`C00719294/schedule_a:37323`, `:35762`). That's exactly the amount refunded in February.
- After the refund, the campaign's running total for API PAC starts over at $1,500.00 and climbs to exactly **$5,000.00** with the March check (`:28851`, `:27718`). The JFC's own running total for API PAC also tops out at $5,000.00.
- $3,500 happens to be the ceiling for a PAC that has *not* qualified as "multicandidate" under FEC rules; $5,000 is the ceiling for one that has. This dataset can't determine API PAC's status on its own (see Methodology). Either way, this is a contribution-limit story, not a processing error.

**BRETT PAC ("Bringing Republican Excellence To Town"), Louisville, Ky.: $2,500.00 refunded by the principal committee on 2026-09-22.**
- BRETT PAC gives the campaign $5,000.00 on 2026-09-03. The FEC filing shows that check bringing its running total to $7,500.00, against a $5,000 per-election limit (`fec/C00719294/efile-2026-10-18T10_21_08.csv:198`).
- The $2,500.00 excess comes back nineteen days later (`efile-2026-10-18T10_21_47.csv:161`).

## Business-entity checks returned in full

The joint fundraising committee refunds eight checks written in the name of a business rather than a person, in every case the entire amount. All eight are filed on the FEC's individual-contribution line with entity code "ORG." That code covers LLCs, partnerships, professional practices and similar entities.

| Contributor | City | Received | Amount | Refunded | Source rows |
|---|---|---|---:|---|---|
| Miles Boldrick Statewide Minerals Co. | Midland, TX | 2026-04-28 | $12,000.00 | 2026-05-28 | `C00753913/schedule_a:2402` / `schedule_b:1133` |
| Happy Hearts Psychiatry | Odessa, TX | 2026-08-20 | $3,500.00 | 2026-09-16 | `efile…28_55.csv:130` / `efile…29_44.csv:35` |
| Basin Computer Services LLC | Odessa, TX | 2026-08-20 | $3,500.00 | 2026-09-16 | `efile…28_55.csv:157` / `efile…29_44.csv:37` |
| Sushruta Surgical Associates PLLC | Odessa, TX | 2026-08-20 | $1,500.00 | 2026-09-16 | `efile…28_55.csv:87` / `efile…29_44.csv:64` |
| MedSeven Prime LLC | Odessa, TX | 2026-08-20 | $1,000.00 | 2026-09-16 | `efile…28_55.csv:114` / `efile…29_44.csv:33` |
| Intergra Alliance dba IntegraGC | Dallas, TX | 2026-08-20 | $1,000.00 | 2026-09-16 | `efile…28_55.csv:126` / `efile…29_44.csv:34` |
| Chris Hirt Farms | Garden City, TX | 2026-08-13 | $500.00 | 2026-09-11 | `efile…28_55.csv:151` / `efile…29_44.csv:36` |
| Niren Patel & Associates PC | Plano, TX | 2026-08-20 | $250.00 | 2026-09-16 | `efile…28_55.csv:107` / `efile…29_44.csv:32` |
| **Total** | | | **$23,250.00** | | |

(The `efile…` files are `fec/C00753913/efile-2026-10-18T10_28_55.csv` for receipts and `fec/C00753913/efile-2026-10-18T10_29_44.csv` for refunds.)

Two features set this group apart from the cap cases. **Every refund is for the entire amount, not an excess.** And **seven of the eight checks arrive within a week of each other in August and are returned together in mid-September.** That is the shape of a committee reviewing a batch of business-name checks and returning them, not of anyone's running total crossing a limit.

Federal law bars contributions from corporations. Under FEC rules, an LLC that elects corporate tax treatment counts as a corporation, and so do many professional corporations. An LLC or partnership that doesn't elect corporate treatment may contribute, but its contribution must be attributed to its individual members or partners. A full refund is consistent with either problem: an impermissible corporate source, or a missing attribution. This report doesn't determine which applies to any one check.

Two caveats on this group:
- **The analysis tool flags three of these as cap cases.** Miles Boldrick Statewide Minerals ($12,000) and the two $3,500.00 checks are flagged as at-cap because their totals meet or exceed the $3,500 individual-line limit. But a joint fundraising committee can lawfully accept far more than $3,500 from one person, because it divides the money among its participants. For a $12,000 business check to a JFC, the cap reading is weaker than the source reading. That's why all three appear here, not above.
- **Two other ORG-coded checks are not refunded as of Sept. 30, 2026:** $5,000.00 from TPS Hospitality, LLC (Odessa, 2026-08-20, `efile…28_55.csv:85`) and $7,000.00 from L M Sales Associates (Bryn Mawr, Pa., 2026-09-25, `efile…28_55.csv:119`). Either may have a member attribution on file, or may simply arrive too late for the September batch.

On Boldrick specifically: two Boldrick family members, Laurie and Miles individually, are established donors to Pfluger's committees in earlier cycles. "Statewide Minerals Co." itself has no contribution row in any earlier cycle in this dataset. Local data alone can't say whether this is the family giving through a company account or a related but distinct contributor.

## Refunded for other reasons

Every non-cap refunded donor this analysis finds, all 23 of them, listed in full under this report's no-word-limit rule for this section. There are fewer than 100, so "top 100" here simply means "all." The eight business-entity refunds above appear again here so this table is complete.

| # | Donor | Refunded | Total contributed | Employer | Occupation | City, State |
|---|---|---:|---:|---|---|---|
| 1 | Miles Boldrick Statewide Minerals Co. | $12,000.00 | $12,000.00 | — | — | Midland, TX |
| 2 | Happy Hearts Psychiatry | $3,500.00 | $3,500.00 | — | — | Odessa, TX |
| 3 | Basin Computer Services LLC | $3,500.00 | $3,500.00 | — | — | Odessa, TX |
| 4 | Fening, Daniel | $1,652.40 | $1,639.90 | Retired | Retired | Northfield, OH |
| 5 | Sushruta Surgical Associates PLLC | $1,500.00 | $1,500.00 | — | — | Odessa, TX |
| 6 | Piper, Jeffrey | $1,000.00 | $1,000.00 | Retired | Retired | Alpena, MI |
| 7 | MedSeven Prime LLC | $1,000.00 | $1,000.00 | — | — | Odessa, TX |
| 8 | Intergra Alliance dba IntegraGC | $1,000.00 | $1,000.00 | — | — | Dallas, TX |
| 9 | Gail, Theo | $977.55 | $977.55 | Retired | Retired | Redding, CA |
| 10 | Keen, Sandy | $698.25 | $871.17 | Retired | Retired | Gainesville, GA |
| 11 | Lindecker, Yvonne | $535.85 | $1,375.05 | Retired | Retired | Volcano, CA |
| 12 | Chris Hirt Farms | $500.00 | $500.00 | — | — | Garden City, TX |
| 13 | Aven, Marva | $351.00 | $351.00 | Retired | Retired | Memphis, TN |
| 14 | Gomez, Kathleen | $342.77 | $328.26 | Retired | Retired | Chalmette, LA |
| 15 | Grimmer, Kathleen | $332.16 | $970.38 | Retired | Retired | Cedar Lake, IN |
| 16 | Stokes, Patsy | $328.90 | $391.40 | Retired | Retired | Virginia Beach, VA |
| 17 | Rondero, Nieves | $318.25 | $318.25 | Retired | Retired | San Diego, CA |
| 18 | Orman, Donna | $290.00 | $290.00 | Retired | Retired | Franklin, IN |
| 19 | Yancey, Jo Ann | $287.35 | $563.05 | Retired | Retired | Conroe, TX |
| 20 | Penry, Diane | $276.45 | $276.45 | Retired | Retired | Desert Hot Springs, CA |
| 21 | Niren Patel & Associates PC | $250.00 | $250.00 | — | — | Plano, TX |
| 22 | Brown County Water Dist. No. 1 | $250.00 | $250.00 | — | — | Brownwood, TX |
| 23 | Knee, Dennis | $104.60 | $783.17 | Retired | Retired | Olathe, KS |

**Total: $30,995.53.** That's $23,250.00 in business-entity refunds plus $7,745.53 in the 15 refunds for other reasons.

A few things stand out:

- **Fourteen of the fifteen non-business refunds go to retirees, and most are full or near-full refunds of everything they gave.** Piper, Gail, Aven, Rondero, Orman and Penry are refunded to the penny. None of these amounts comes close to the $3,500/$5,000 per-election ceilings; the largest, Fening's $1,652.40, is under half the individual limit. This is the pattern of a campaign reversing specific transactions (a declined card, a duplicate charge, a donor's own request), not trimming someone to a legal maximum.
- **Several are batch refunds of tiny, recurring online gifts on a single day:**
  - Fening's refund spans dozens of line items, some as small as $0.95, all dated 2025-09-22.
  - Grimmer's spans dozens more, as small as $1.00, all dated 2025-06-30.
  - In the third quarter of 2026, Dennis Knee's $104.60 comes back in 29 line items on 2026-08-10, some as small as one cent.
  - Yvonne Lindecker's $535.85 comes back in 21 line items on 2026-09-21, which is exactly her July–August giving.
  - Jo Ann Yancey's $287.35 comes back in 10 line items on 2026-07-20.

  These read like a payment processor or a campaign batch-refunding a run of small recurring charges, not person-by-person judgments about individual gifts.
- **Brown County Water District No. 1 is a Texas water district: a unit of local government, not a person or a private company.** Its $250.00 check (2025-03-10) is refunded a month later (`C00719294/schedule_b:7623`). Contributions from government entities can run into federal source restrictions that have nothing to do with dollar amount. A full refund is consistent with the campaign catching and returning an impermissible-source contribution, though this report doesn't independently confirm a legal problem existed.
- **Kathleen Gomez's refund ($342.77) is $14.51 more than her recorded contributions ($328.26).** Her ten contribution rows (2026-05-19 through 2026-06-01, $0.26 to $100.00) match ten of her twelve refund line items exactly. The other two refund rows, a second $0.26 and a $14.25, have no matching contribution row. That's small enough to be a processing artifact rather than a real data problem, but it's flagged here rather than quietly netted away.

## Takeaways

1. **Business-entity checks are the cycle's biggest refund category.** The JFC returns $23,250.00 in full to eight LLCs, practices and a farm, seven of them in one September batch. That's more than all the true cap trims combined. It points to the committee screening checks for source problems, not just dollar limits.
2. **The real cap cases are clean and recent.** Safari Club's PAC, BRETT PAC, and two Wisconsin individuals each have a filed running total that visibly passes the per-election limit, and each gets back the excess, not the whole gift. Four of the six cap refunds come in the third quarter of 2026, as general-election money arrives.
3. **The JFC structure blurs "did this donor hit the limit?"** API PAC's refund only makes sense once the JFC's own running total is separated from what had been passed through to the campaign specifically. And the analysis tool's own cap check flags business checks to the JFC as "at cap" even though a JFC can lawfully accept much more.
4. **Fourteen of the fifteen remaining refunds go to retirees,** mostly as full refunds of small recurring online gifts, often in single-day batches. That looks like transaction-level reversals, not judgments about anyone's giving.
5. **A local government unit (Brown County Water District No. 1) appears among the refunded donors.** It's worth a human's attention as a possible impermissible-source correction, separate from any contribution-limit question.

## Caveats

**Donor identity between refunds (Schedule B) and contributions (Schedule A) is matched by name only.** Refund rows carry no employer field to tell apart two people who share a name. Raw third-quarter 2026 filings make this harder: they list individual refund recipients by surname alone ("WILEY," "DEBOER," "KNEE," "LINDECKER," "YANCEY"). For those five, this report matches the refund to the contribution by surname, city and state, and by timing, and names the person accordingly. None of the 29 donors here has an obvious same-name collision, but this isn't verified beyond that.

**The $3,500 individual and $5,000 multicandidate-PAC per-election limits are the published 2025–2026 figures, not something derived from the data.** They are hard-coded into the underlying tool and worth re-confirming against FEC.gov if limits change.

**Money moving through Pfluger's joint fundraising committees complicates "did this donor hit the limit?"** A donor's real limit applies per candidate, across every authorized committee combined. But a JFC also pools money for participants other than Pfluger's own committees (this cycle, the NRCC and others), and this report's cap check sees only what Pfluger's four collected committees show.

**Small unexplained gaps are flagged rather than resolved.** Daniel Fening's refund ($1,652.40) is $12.50 more than his recorded 2026 contributions ($1,639.90). Kathleen Gomez's is $14.51 more. Richard DeBoer's $10.75 contribution is marked for a refund that doesn't appear in the data. Each could be a processing-fee reversal, a contribution recorded outside this report's scope, or a minor data quirk.

**No claim is made that any refund here reflects an actual FEC violation.** A refund is exactly the mechanism campaigns are supposed to use to stay compliant; every refund here represents the system working, not evidence of wrongdoing. This report traces the money and offers a data-grounded read of *why* each refund likely happened. It does not, and cannot, establish legal fault.

This is also a small dataset: 29 donors and $53,994.78. Every percentage above is sensitive to a single check. The Boldrick refund alone is 22.2% of every dollar refunded this cycle.

---

# Methodology & AI Transparency Appendix

*(This section is excluded from the report's word-count consideration, per this project's standing convention.)*

**Report generated:** 2026-10-18, by Claude Opus 5.5 (Anthropic, model ID `claude-opus-5-5`), running as Claude Code inside the VS Code extension, on behalf of user Tod Beardsley. The interface doesn't expose sampling settings such as temperature or maximum output tokens, so the session ran on its defaults.

**Data sources:**
- FEC Schedule A (receipts) and Schedule B (disbursements) exports for all four of August Pfluger's 2026-cycle committees, exported by hand from fec.gov on 2026-10-18: `tx-11/august-pfluger/fec/C00719294/`, `/C00749481/`, `/C00753913/` and `/C00840033/`.
- Each committee's raw `efile-*.csv` submissions. The processed exports end on 2026-06-30 for the campaign and the JFC, and their raw efile data runs through 2026-09-30. The tool folds in those third-quarter rows, including 11 of the refunds above, deduplicated as described in `tooling/analyze-candidate.rb` gotcha 8 and `tooling/lib/efile_dedup.rb`. The campaign's third-quarter efile contains an original filing and an amendment with identical rows (file numbers 2025566 and 2028678); each refund is counted once.
- The committee directory `C00857649` carries a `CONNECTED` marker (an outside, multi-candidate joint fundraising committee) and is excluded.
- The report is scoped to the 2026 two-year FEC cycle (`two_year_transaction_period` = 2026; efile gap rows by calendar year).

**Command run:**
```
ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --refunds --format json --out <scratch>/pfluger-refunds.json
```
It reports 29 net-refunded donors and $53,994.78: 7 flagged at-cap and 22 "other reasons." This report regroups three of the tool's seven at-cap donors into the business-entity group, for the reason given in that section (a JFC can lawfully accept far more than $3,500 from one person). The tool couldn't match five third-quarter refunds to a contribution, because raw efile Schedule B lists individual payees by surname only (`analyze-candidate.rb` gotcha 11). Those five were matched by hand against Schedule A and the raw efile receipts by surname, city, state and timing. Wiley and DeBoer each turn out to be clear cap cases; Knee, Lindecker and Yancey are small-dollar batch refunds.

**Verification performed:** every dollar figure, date and donor detail above was checked directly against the source CSV rows before publication. The checks include:
- the API PAC and Safari Club running-total timelines, reconstructed row by row from both the JFC's receipts and the campaign's attribution rows;
- the third-quarter business-entity receipts and refunds, matched check by check;
- the five surname-only refunds, matched to their contributions;
- the Gomez ten-contribution/twelve-refund mismatch, reconstructed line by line.

**Web research:** none for this run. E-PAC's identity (Rep. Elise Stefanik's leadership PAC, also branded Elevate PAC) comes from this project's earlier research. The FEC's treatment of LLCs and professional corporations as contributors comes from the model's general knowledge of published FEC guidance; verify it independently. API PAC's multicandidate status, which would settle the reason for its refund, was deliberately not looked up. That's consistent with this project's rule against analysis prompts reaching outside the data on disk for anything beyond identifying a named committee.

**Prompt for this run:**

> Roll through the reports in tx-11/august-pfluger/reports/2026-* and regenerate these with the new data available, otherwise keeping the original prompts as recorded. Don't compare to prior runs of the analysis, keep everything in the present tense for a new reader.

**Original prompt, as recorded for this report:**

> CANDIDATE: `August Pfluger`
> DISTRICT: `TX-11`
> CYCLE: `2026`
>
> Create a report, per the top-level README rules, detailing August Pfluger of TX-11, of the donors that requested refunds. Make a distinction between those donors that likely hit the donor cap versus those that appear to have requested the refund for other reasons.

> [mid-session follow-up] Save the report to tx-11/reports/2026-donor-refunds.md

> [mid-session follow-up, after a clarifying question about the path resolved to the per-candidate `reports/` convention] Save the top 100 non-cap-hitting refunded donors as its own section in the final report. Ignore the word limits for this section.

> [mid-session follow-up] Include the usual demographic data - occupation, employer, and city/state.

**Limitations and things a human should double-check before citing this report further:**

- Donor identity between Schedule B refunds and Schedule A contributions is matched by name only, and by surname, city and timing for the five raw-efile refunds; see Caveats.
- The $3,500 and $5,000 limits are hard-coded 2025–2026 figures, not derived from a live FEC lookup.
- The business-entity reading (corporate source or missing attribution) is a plausible explanation for full refunds of ORG-coded checks, not a determination about any one contributor's tax status.
- The API PAC classification is a best-effort read of ambiguous data; this report doesn't claim certainty about which limit rule applied.
- No claim is made that any contribution or refund here violates, or complies with, any FEC rule. This report traces the money and offers a plausible read, not a legal determination.
