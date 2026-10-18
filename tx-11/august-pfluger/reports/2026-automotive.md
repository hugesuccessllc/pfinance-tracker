# TX-11: August Pfluger — The Automotive Industry, on Both Sides of the Ledger

*Where car dealers, automakers and rental-car companies show up in August Pfluger's 2026-cycle money: the money coming in from the industry, and the money the campaign itself spends on cars.*

## The short version

Automotive money is a minor character in August Pfluger's 2026-cycle fundraising compared with oil and gas (see this project's companion report, `2026-oil-and-gas.md`). But it shows up on **both sides of the ledger**, and the two sides connect.

**Money in: $44,000.** That's the itemized 2026-cycle donor money that traces to the auto industry, **0.76%** of the $5,767,705.50 in itemized donor receipts across Pfluger's four committees. It comes from:
- a four-generation West Texas car-dealer family, the Sewells, who own Sewell Ford Lincoln in Odessa and other brands under "The Sewell Family of Companies";
- PAC checks from General Motors, Toyota and the National Automobile Dealers Association;
- Polaris, the maker of ATVs, snowmobiles and Indian Motorcycles.

**Money out: $33,457.90.** That's what Pfluger's committees spend on automotive vendors, **0.34%** of $9,699,903.36 in itemized 2026-cycle spending. It covers rental cars and a car wash. Most notably, it includes **a recurring monthly "CAR PAYMENT" to Lincoln Ford Credit that looks like financing a vehicle rather than renting one**, plus a one-time $1,004.62 payment to **Sewell Ford** itself, the same Odessa dealership whose managing partner is a Pfluger donor.

Both totals are small next to the oil-and-gas figures this project documents for Pfluger, and that is itself the finding: automotive isn't a defining industry in his fundraising the way West Texas oil is. What's here is still worth a look:
- a long-running, family-run dealer group giving five figures;
- a car-payment pattern in the spending data that's unusual enough to flag;
- one donor whose filed occupation doesn't match their public biography at all.

## Money coming in: the Sewells and the industry PACs

### The Sewell Family of Companies — $20,000

**Collin Sewell**, filed as "President" of "THE SEWELL FAMILY OF COMPANIES," gives **$12,000** on 2025-12-22 (`fec/C00753913/schedule_a-2026-10-18T10_28_44.csv:2634`). Public reporting confirms Collin Sewell leads the Sewell Family of Companies ([Team Sewell](https://www.teamsewell.com/aboutus); [The Beacon](https://thebeaconpermian.com/bio/collin-sewell/)). It is a fourth-generation Odessa auto-dealer group dating back to 1911 that operates Ford, Lincoln, BMW, Cadillac and other brands in Odessa, Midland and Andrews. Odessa is inside TX-11.

**Canda Sewell** gives **$7,500** in two checks, filed as CEO of the same company: $2,500 on 2026-02-13 (`:2558`) and $5,000 on 2026-02-17 (`:2550`). One quirk in the filed data: both of her rows have the employer and occupation fields swapped. `contributor_employer` reads "CEO" and `contributor_occupation` reads "SEWELL FAMILY OF COMPANIES." That's a data-entry swap on the filer's side, and the meaning is clear either way.

**Paul Crump Jr.**, managing partner of **Sewell Ford Lincoln** specifically (the Odessa store, not the parent company), gives **$500** on 2025-06-30 (`:2875`).

All three gifts go to the **Pfluger Victory Fund**, Pfluger's joint fundraising committee (JFC). None goes to the principal campaign or Raptor PAC.

### Industry PACs — $21,000

| PAC | Amount | Committee | Dates and source rows |
|---|---|---|---|
| National Automobile Dealers Association PAC | $10,000 | C00753913 | $2,500 on 2025-08-01 (`fec/C00753913/schedule_a-2026-10-18T10_28_44.csv:2824`); $2,500 on 2026-02-17 (`:2548`); $5,000 on 2026-06-30 (`:2160`) |
| Toyota Motor North America, Inc. PAC | $6,000 | C00719294, C00753913 | $2,500 on 2025-03-19 and $1,000 on 2026-03-17, both C00719294 (`fec/C00719294/schedule_a-2026-10-18T10_20_55.csv:40387`, `:27213`); $2,500 on 2026-06-30, C00753913 (`fec/C00753913/schedule_a-2026-10-18T10_28_44.csv:2150`) |
| General Motors Company PAC (GM PAC) | $5,000 | C00719294, C00753913 | $2,500 on 2025-05-30, C00719294 (`fec/C00719294/schedule_a-2026-10-18T10_20_55.csv:37598`); $2,500 on 2026-08-11, C00753913, in the raw third-quarter filing (`fec/C00753913/efile-2026-10-18T10_28_55.csv:36`) |

### Adjacent, not core — Polaris Industries — $3,000

**Polaris Industries Political Participation Program** gives $1,000 on 2025-06-30 (`C00753913/schedule_a:2853`) and $2,000 on 2026-03-03 (`:2499`). Polaris makes ATVs, snowmobiles and Indian Motorcycles: powersports, not passenger cars. It's included in the $44,000 headline because "automotive industry" reasonably stretches to cover motor-vehicle manufacturing broadly. A reader who draws the line at cars and trucks only would put it in its own bucket.

## What counted, and what didn't

This report starts the way this project's oil-and-gas report does. An automated keyword scan (`tooling/donor-keyword-scan.rb`) searches every donor's name, employer and occupation, including the raw third-quarter 2026 filings, and then every match is reviewed by hand. The manual pass matters even more here, because several of the most tempting keywords turn out to be almost pure noise:

- **"tire" matches "RETIRED."** All 9,266 "tire" hits are someone's occupation field reading "RETIRED," not a tire company: $597,528.31 of noise from a single bad keyword. Dropped entirely.
- **"gm" and "ford" as bare substrings are mostly surnames.** All of these match on spelling alone, and none is in the total:
  - Kingman (×2), Sigmond, Seligmann, Dingman, Lankford, Weatherford (×2), Crawford, Raford Hargrove, Sanford Davis, and "Ford, Diann" (a retiree, no relation)
  - Willson, via employer "Paradigm Home Health," and Wilson, via employer "Ewil Mgmt Co."
  - the "Affordable Housing Tax Credit Coalition PAC," which contains "ford" inside "aFFORDable"
- **The spending side has its own surname problem.** Four Raptor PAC contributions *to other candidates' committees* match "ford" for the same reason:
  - Mark Alford for Congress ($10,000 in two checks)
  - Crawford for Congress ($6,000 in two checks)
  - Tedford for U.S. Congress ($5,000)
  - Citizens for John Rutherford ($2,000)

  So do a $263.91 event-ticket payment to "State of Wexford" and a $2,000 campaign donation to the Travis County Republican Party, which matches "avis" inside "TrAVIS." These are political giving and an unrelated venue charge, not automotive spending, and are excluded.
- **A committee name happens to contain "nada."** TransCanada USA Services, Inc. PAC ($7,500), an energy-pipeline company's PAC, matches the "nada" fragment in "TransCaNADA." Excluded.
- **Ronald Sewell: same surname, different industry, counted elsewhere.** Ronald Sewell gives $10,800 in three checks in the 2026 cycle and shares a surname with the dealer family. But his filed occupation is "LANDMAN" (self-employed), and the same donor appears in `2026-oil-and-gas.md`'s roll call of Permian landmen. Following that report's rule, which trusts the filer's stated occupation rather than a surname, he's excluded here. Counting him would imply the auto-dealer Sewells and the landman Sewell are the same money.
- **Two matches flagged but not counted.**
  - **Meghan Sewell** gives $12,000 on the same date and to the same committee as Collin Sewell (`C00753913/schedule_a:2633`). But her filing lists "SELF" / "HOMEMAKER," with no employer naming the dealer group. She may well be a family member; a spouse is a reasonable guess given the shared date and surname. But nothing in the FEC filing says so, so she's flagged rather than folded into the Sewell total.
  - **Scott Dueser** gives $1,000 on 2025-03-11 (`C00753913/schedule_a:3149`), filed with the same swapped-field pattern as Canda Sewell: employer "CEO," occupation "Sewell Family of Companies." But Scott Dueser is publicly identified as a longtime senior executive of **First Financial Bankshares**, an Abilene-based bank holding company, with no findable public connection to the Sewell dealer group ([First Financial Bankshares proxy filings](https://www.sec.gov/Archives/edgar/data/36029/000119312526095645/ffin-20260306.htm)). He was its CEO and chairman at the time of the gift and is now executive chairman. His filing's city, Abilene, matches his known bank role, not Odessa, where every other Sewell-company donor is listed. This looks like a data-entry mistake, perhaps his row picking up text meant for an adjacent row, rather than a real, undisclosed board seat. Flagged and excluded, not asserted as fact either way.
- **Two insurance PACs match on "automobile" but sell coverage, not cars.** State Farm Mutual Automobile Insurance Company Federal PAC ($2,000) and the United Services Automobile Association (USAA) Employee PAC ($1,000) are insurers whose names happen to contain "Automobile." Neither is in the headline total.
- **William Kliewer**, filed as "AUTO DEALER INSURANCE EXEC" at BKCW LP ($2,500, `C00719294/schedule_a:40417`), works at a real Killeen insurance agency, Bigham Kliewer Chapman & Watts ([BKCW Insurance](https://www.bkcw.com/)). It writes general property and casualty lines, including coverage for auto dealers. Insurance sold *to* auto dealers isn't the auto business itself, so it's left out of the headline total and noted here for completeness.

The same donor-scope rule this project uses elsewhere applies here. Only rows the FEC's own `line_number_label` marks as "Contributions From Individuals" or "Contributions From Other Political Committees" count, never a "Transfers from authorized committees" row.

## Money going out: rental cars, a car wash, and a car payment

A sibling tool, `tooling/vendor-keyword-scan.rb`, scans the committees' spending records (Schedule B) for automotive vendor names, including the raw third-quarter 2026 filings. After exclusions it finds **$33,457.90** across 93 line items, nearly all on the principal committee and one on the JFC. That's small next to roughly $9.70 million in total 2026-cycle itemized spending, but one pattern is worth a closer look.

### The car payment

| Period | Payee | Payment |
|---|---|---|
| Jan.–Sept. 2025 (9 payments) | Lincoln Ford Credit | **$669.59** a month |
| 2025-10-20 | **Sewell Ford** | **$1,004.62**, one time |
| Nov. 2025–Sept. 2026 (11 payments) | Lincoln Ford Credit | **$975.03** a month, plus a one-off **$395.00** on 2025-11-24 |

The details:
- The first payment to **"LINCOLN FORD CREDIT"** is on 2025-01-21 (`fec/C00719294/schedule_b-2026-10-18T10_21_28.csv:8256`), and the $669.59 payments run through 2025-09-16 (`:8264`).
- The Sewell Ford payment (`:8491`) goes to the same Odessa Ford/Lincoln dealership whose managing partner, Paul Crump Jr., is a $500 donor above.
- The step-up to $975.03 starts on **2025-11-07** (`:8446`).
- The latest three payments, on 2026-07-13, 2026-08-10 and 2026-09-11, appear so far only in the raw third-quarter filing (`fec/C00719294/efile-2026-10-18T10_21_47.csv:12`, `:345`, `:422`).

In all, Lincoln Ford Credit receives **$17,146.64 in 21 payments** from January 2025 through September 2026. Every processed-export payment carries the FEC spending category "Travel Expenses."

The timing, a lump payment to the dealership just as the monthly amount jumps, is consistent with a vehicle trade-in, refinance or upgrade in October or November 2025. The filings don't say so, and this report doesn't guess beyond what's filed.

"LINCOLN FORD CREDIT" most likely refers to **Lincoln Automotive Financial Services**, the Lincoln-brand financing arm of Ford Motor Credit Company ([Ford Media Center](https://www.fromtheroad.ford.com/us/en/articles/2024/consumers--ford-credit--lincoln-automotive-financial-services-no)). But the filing lists the payee's city as San Angelo, Pfluger's hometown, not Odessa, where Sewell Ford is. And no company named exactly "Lincoln Ford Credit" turns up independently. Treat that identification as a strong inference, not a confirmed fact.

**A recurring loan-style "car payment" is a different animal from a rental-car receipt.** Committees more commonly lease or rent vehicles for campaign use. An ongoing payment toward what reads like a purchase or finance agreement raises the kind of personal-use question the FEC's rules on campaign-owned assets exist to police.

This report makes no claim that anything here is improper:
- the payments are disclosed exactly as filed;
- campaign funds paying for a "CAR PAYMENT" line coded "Travel Expenses" isn't improper in itself;
- this project lacks the additional facts (title, ownership, what happens to the vehicle after the campaign) needed to say more.

It's flagged because the pattern is unusual enough to merit a future look, not because the numbers show a violation.

### Rental cars and a car wash

The rest of the automotive spending is more ordinary campaign travel:

| Vendor | Amount | Charges |
|---|---|---|
| Hertz | $5,752.06 | 15 charges, Dec. 2024–April 2026, in Waco, Miami, Oklahoma City, Washington and Dallas–Fort Worth |
| Budget | $3,735.39 | 8 charges, filed as "BUDGET RENT-A-CAR," "BUDGET RENT A CAR" and "BUDGET CAR RENTAL," the latest in July 2026 |
| **Yates Car Wash & Detail Center** (Alexandria, Va.) | $1,420.00 | 32 small recurring charges, March 2025–July 2026, filed alternately as "CAR MAINTENANCE" and "VEHICLE MAINTENANCE" |
| Enterprise Rent-A-Car | $1,319.48 | 3 charges |
| Avis | $1,065.41 | 4 charges |
| Campbell Concierge | $695.99 | 1 charge, described as "CAR RENTAL"; a small or regional service this report can't identify beyond the filing's own description |
| National Car Rental | $586.51 | 1 charge, on the JFC rather than the principal committee |
| Turo | $582.10 | 2 charges |
| Amex "Premium Car Rental Protection" | $149.70 | 6 charges, a rental-insurance add-on rather than the rental itself |

Yates Car Wash & Detail Center is in Alexandria, Va., across the Potomac from Washington. That suggests routine upkeep on a Washington-area vehicle, separate from whatever the Lincoln Ford Credit payments finance in Texas.

## Takeaways

1. **Automotive is a minor industry in Pfluger's fundraising and spending, and that's worth saying plainly.** $44,000 of $5.77 million in itemized 2026 receipts (0.76%), and $33,457.90 of $9.70 million in itemized 2026 spending (0.34%), are nowhere near the roughly one-in-four-dollar share this project documents for oil and gas. That's a useful contrast, not a non-finding.
2. **The industry money that does exist comes from a tight, identifiable circle.** One four-generation Odessa dealer family, the Sewells, accounts for $20,000 of the $44,000 (45%), all through the JFC.
3. **The campaign's own car spending tells a small story of its own.** There's a recurring "CAR PAYMENT" to a Ford-affiliated finance company, still running in September 2026. It steps up right after a lump payment to the same Odessa Ford dealership whose managing partner donates to the campaign. This report flags that pattern for a deeper look rather than resolving it here.
4. **Manual review is essential, not optional.** A single keyword, "tire," would inflate the receipts total by nearly $600,000 if taken at face value, matching "RETIRED" 9,266 times. Surnames and a place name (Wexford) account for most of the rest of the keyword noise, along with "Travis" hiding "avis."
5. **One donor's filed identity doesn't match his public one, and one personal disclosure brushes against this topic.** Scott Dueser's occupation field ties him to the Sewell dealer group, but everything publicly findable ties him to an unrelated Abilene bank. Separately, Pfluger's own March 2026 stock-purchase disclosure (a Periodic Transaction Report filed with the House) includes Amerco, U-Haul's parent company, and Enterprise Products Partners, an oil-and-gas pipeline company covered elsewhere. Neither is campaign committee money, so neither counts in any total above, but both are close enough to this report's subject to name.

## Caveats

This is a keyword-and-manual-review exercise, not an FEC industry classification; there's no "automotive" checkbox on a Schedule A or B filing. A donor's or vendor's free-text employer, occupation or description field can be blank, stale, or not descriptive enough to catch. A company or vendor whose name the keyword list doesn't anticipate won't appear here even if it belongs.

Every dollar figure and file:line citation above was checked against the source CSV before publication. Where a filing doesn't make a connection obvious, vendor and donor identification relies on web research: "Lincoln Ford Credit," the Sewell Family of Companies, BKCW/Kliewer, Scott Dueser. It's flagged as inference rather than fact where that research falls short; Campbell Concierge remains unidentified.

As always, legal, fully disclosed campaign contributions and spending are not evidence of anything improper by themselves. This report counts and traces the money and leaves judgment about what it means to the reader.

---

# Methodology & AI Transparency Appendix

*(This section is explicitly excluded from the report's word-count limit.)*

**Report generated:** 2026-10-18, by Claude Opus 5.5 (Anthropic, model ID `claude-opus-5-5`), running as Claude Code inside the VS Code extension, on behalf of user Tod Beardsley. The interface doesn't expose sampling settings such as temperature or maximum output tokens, so the session ran on its defaults.

**Data sources:**

- FEC Schedule A (receipts) and Schedule B (disbursements) exports for August Pfluger's four 2026-cycle committees, exported by hand from fec.gov on 2026-10-18 and stored under `tx-11/august-pfluger/fec/`:
  - `C00719294`: August Pfluger for Congress (principal committee)
  - `C00749481`: Raptor PAC (leadership PAC)
  - `C00753913`: Pfluger Victory Fund (joint fundraising committee)
  - `C00840033`: Pfriends of Pfluger, a second, much smaller joint fundraising committee, with no automotive-related activity in either scan
- **Raw efile gap.** The processed exports end on 2026-06-30 (2026-06-26 for the JFC's disbursements). The committees' raw `efile-*.csv` submissions extend the campaign and the JFC through 2026-09-30. Both scan tools fold in those third-quarter rows via `--include-efile-gap`, deduplicated as described in `tooling/lib/efile_dedup.rb`. The campaign's third-quarter efile contains an original filing and an amendment with identical rows; each charge is counted once. Gap rows in this report include GM PAC's August 2026 check, three Lincoln Ford Credit payments, a Budget rental and Yates car-wash charges.
- The committee directory `C00857649` carries a `CONNECTED` marker (an outside joint fundraising committee) and is excluded from every figure here.
- House Ethics Committee data (personal financial disclosure) was checked but isn't part of any total. Pfluger's March 2026 Periodic Transaction Report lists purchases of Amerco (U-Haul's parent) and Enterprise Products Partners. Neither is campaign committee money, which is this report's subject; both are named in Takeaway 5 for completeness.
- The report is scoped to the 2026 two-year FEC cycle: `two_year_transaction_period` = 2026 for processed rows, and calendar years 2025–2026 for efile gap rows.

**Tooling used:**

- `tooling/analyze-candidate.rb`, run first for baseline totals and the `EFILE COVERAGE WARNING` state:
  ```
  ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics --cycle 2026 --top 40
  ```
  Its committee subtotals, under "RECEIPTS (itemized, non-memo, donor rows only)" and "DISBURSEMENTS (itemized, non-memo)," are the source for the $5,767,705.50 receipts and $9,699,903.36 disbursements figures used for this report's percentages.
- `tooling/donor-keyword-scan.rb`, for receipts:
  ```
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "Automotive=automotive,automobile,auto dealer,auto group,dealership,car dealer,dealer group,motors,ford,gm,general motors,toyota,honda,nissan,hyundai,kia,subaru,volkswagen,bmw,mercedes,lexus,mazda,mitsubishi,chevrolet,chevy,dodge,cadillac,buick,gmc,jeep,chrysler,stellantis,tesla,rivian,polaris,national automobile dealers,nada,carmax,autonation,sewell,car sales,auto sales,tire,valvoline,jiffy lube,napa,autozone,o'reilly,advance auto,pep boys,firestone,goodyear,mechanic,auto repair,auto body"
  ```
  Every one of the 9,385 matches was reviewed. After the 9,266 "tire"/"RETIRED" rows were set aside, 119 rows across 30 entities remained, and each was reviewed by hand; see "What counted, and what didn't."
- `tooling/vendor-keyword-scan.rb`, for disbursements:
  ```
  ruby tooling/vendor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "Automotive=hertz,avis,enterprise rent,budget rent,national car rental,alamo rent,u-haul,uhaul,car rental,vehicle lease,auto lease,dealership,ford,chevrolet,chevy,toyota,honda,nissan,jeep,dodge,chrysler,gmc,cadillac,buick,tesla,rivian,jiffy lube,valvoline,discount tire,firestone,goodyear,pep boys,autozone,o'reilly auto,advance auto,napa auto,carmax,autonation,vehicle purchase,vehicle maintenance,auto repair,car wash,tire,oil change,mechanic,sewell,car payment,turo,rent-a-car,rent a car"
  ```
  All 102 matches ($58,721.81) were reviewed by hand. Nine are excluded ($25,263.91): Raptor PAC's contributions to four "-ford" candidates, the Travis County Republican Party donation, and the State of Wexford ticket.
- **Tool fixes during this run.** Three fixes to the scan tools came out of this run's reports, each documented in the tool headers and covered by specs:
  - **CONNECTED committees.** The shared committee lister (`tooling/lib/fec_committees.rb`) now skips `CONNECTED`-marked directories.
  - **Entity types in the gap window.** `donor-keyword-scan.rb`'s efile gap now accepts business entities ("ORG") on the individual line and non-"PAC" committee codes.
  - **Deduplication.** `vendor-keyword-scan.rb`'s efile gap now deduplicates original and amended filings.
- Single-use Ruby one-liners, not saved as tooling, computed the per-vendor and per-donor subtotals, brand groupings and percentages from the two scans' JSON output.

**Verification performed:** every dollar figure and file:line citation in the body was checked against the source CSV directly before publication. The Ronald Sewell exclusion matches `2026-oil-and-gas.md`, which reports the same $10,800, three-check total for the same donor under its landmen roll call. The Lincoln Ford Credit total ($17,146.64 in 21 payments) was summed payment by payment from the cited rows.

**Web research:** only to verify the *nature* of ambiguous donors, companies and vendors (what industry they're in, or whether a named entity can be identified at all), never to set or adjust a dollar figure. Every dollar amount in this report comes from the local FEC CSV data. The identifications reused here, with sources linked inline, cover Collin Sewell and the Sewell Family of Companies, BKCW LP / Bigham Kliewer Chapman & Watts, Scott Dueser's role at First Financial Bankshares, and Lincoln Automotive Financial Services / Ford Motor Credit. "Campbell Concierge" has no confirmed identification. None of these sources was re-fetched for this run.

**Prompt for this run:**

> Roll through the reports in tx-11/august-pfluger/reports/2026-* and regenerate these with the new data available, otherwise keeping the original prompts as recorded. Don't compare to prior runs of the analysis, keep everything in the present tense for a new reader.

**Original prompt, as recorded for this report:**

> CANDIDATE: `August Pfluger`
> DISTRICT: `TX-11`
> CYCLE: `2026`
>
> Using the rules in this repo's top-level README.md, and following the style of tx-11/august-pfuger/2026-oil-and-gas.md, write a report detailing any automotive industry contributions or disbursements August Pfluger of TX-11 is involved in. You may use normal web searches to verify automotive industry things, especially donor employment.
>
> File this under tx-11/august-pfluger/reports/2026-automotive.md.

> [mid-session follow-up] Be sure to include efile data.

**Limitations and things a human should double-check before citing this report further:**

- This is a single-cycle (2026) snapshot of both receipts and spending as of the 2026-10-18 data export. It says nothing about automotive-industry giving or spending in Pfluger's earlier cycles.
- Keyword matching plus manual review is a blunt instrument in both directions. It over-matches badly on generic substrings ("tire" inside "retired," "ford" and "gm" inside ordinary surnames, "avis" inside "Travis"). It could just as easily miss a real automotive donor or vendor whose name the keyword list doesn't anticipate.
- The "Lincoln Ford Credit" identification, and the reading of the October 2025 Sewell Ford payment as a possible vehicle swap or refinance, are this report's best interpretation of the filed data, not confirmed facts. Someone with access to the campaign's own records could confirm or correct either.
- No claim is made that any contribution or payment here exceeds a legal limit, violates FEC personal-use rules or otherwise breaks FEC rules. Nothing in this report suggests that on its own, and it doesn't attempt to check.
