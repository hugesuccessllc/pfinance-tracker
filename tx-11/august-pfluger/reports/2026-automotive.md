# TX-11: August Pfluger — The Automotive Industry, on Both Sides of the Ledger

*A look at where car dealers, automakers, and rental-car companies show up in August Pfluger's 2026-cycle money — both money coming in from the industry, and money the campaign itself spends on cars.*

## The short version

Automotive money is a minor character in August Pfluger's 2026-cycle fundraising compared to, say, oil and gas (see this project's companion report, `2026-oil-and-gas.md`) — but it shows up on **both sides of the ledger**, and the two sides connect. On the receipts side, **$41,500** of itemized 2026-cycle donor money traces to the auto industry: a four-generation West Texas car-dealer family (the Sewells, who own Sewell Ford Lincoln in Odessa and nine other brands under "The Sewell Family of Companies"), plus PAC checks from General Motors, Toyota, the National Automobile Dealers Association, and Polaris (ATVs/snowmobiles/Indian Motorcycles). That's **0.78%** of the $5,317,758.43 in itemized donor receipts recorded across Pfluger's four 2026-cycle committees.

On the disbursement side, the campaign's principal committee spent **$30,178.51** — **0.37%** of $8,081,363.33 in itemized 2026 spending — on automotive vendors: rental cars, a car wash, and, most notably, a **recurring monthly car payment to Lincoln Ford Credit that appears to be financing a vehicle rather than renting one**, plus a one-time $1,004.62 payment to **Sewell Ford** itself — the same Odessa dealership whose managing partner is a Pfluger donor.

Both totals are small next to the oil-and-gas numbers this project has already documented for Pfluger, and that's itself the honest finding: automotive isn't a defining industry in his fundraising the way West Texas oil is. What's here is worth a look anyway — a durable, family-run dealer group giving five figures, a car-payment pattern in the spending data that's unusual enough to flag, and one instance where a donor's filed occupation didn't match their public biography at all.

## Money coming in: the Sewells and the industry PACs

### The Sewell Family of Companies — $20,000

**Collin Sewell**, filed as "President" at "THE SEWELL FAMILY OF COMPANIES," gave **$12,000** on 2025-12-22 (`fec/C00753913/schedule_a-2026-08-15T11_47_21.csv:3216`). Public reporting confirms Collin Sewell leads the Sewell Family of Companies, a fourth-generation Odessa, TX auto-dealer group tracing back to 1911 that today operates Ford, Lincoln, BMW, Cadillac, and other brands out of Odessa, Midland, and Andrews — Odessa is inside TX-11 ([Team Sewell](https://www.teamsewell.com/aboutus); [The Beacon](https://thebeaconpermian.com/bio/collin-sewell/)).

**Canda Sewell** gave **$7,500** across two checks — $2,500 on 2026-02-13 (`:2739`) and $5,000 on 2026-02-17 (`:3012`) — filed as CEO of the same company. Worth flagging as-filed: both of Canda Sewell's rows have the employer and occupation fields transposed in the raw data (`contributor_employer` reads "CEO," `contributor_occupation` reads "SEWELL FAMILY OF COMPANIES"), a filer-side data-entry swap rather than an error in this report's reading of it — the meaning is unambiguous either way.

**Paul Crump Jr.**, Managing Partner at **Sewell Ford Lincoln** specifically (the Odessa store, not the parent holding company), gave **$500** on 2025-06-30 (`:2341`).

All three gifts went to the **Pfluger Victory Fund** (the JFC), none to the principal campaign or Raptor PAC.

### Industry PACs — $18,500

| PAC | Amount | Committee | Dates |
|---|---|---|---|
| National Automobile Dealers Association PAC | $10,000 | C00753913 | $2,500 on 2025-08-01, filed as "...POLITICAL ACTION COMMITTEE" (`:2842`); $2,500 on 2026-02-17 (`:2754`); $5,000 on 2026-06-30 (`:3059`) — same committee, C00040998, filed under two slightly different name strings |
| Toyota Motor North America, Inc. PAC | $6,000 | C00719294, C00753913 | $2,500 on 2025-03-19 and $1,000 on 2026-03-17, both C00719294 (`fec/C00719294/schedule_a-2026-08-15T11_54_12.csv:41994`, `:41575`); $2,500 on 2026-06-30, C00753913 (`fec/C00753913/schedule_a-2026-08-15T11_47_21.csv:2803`) |
| General Motors Company PAC (GM PAC) | $2,500 | C00719294 | 2025-05-30 (`fec/C00719294/schedule_a-2026-08-15T11_54_12.csv:42036`) |

### Adjacent, not core — Polaris Industries — $3,000

**Polaris Industries Political Participation Program** gave $1,000 on 2025-06-30 (`:2555`) and $2,000 on 2026-03-03 (`:2668`). Polaris makes ATVs, snowmobiles, and Indian Motorcycles — powersports, not passenger-car manufacturing. It's included in the $41,500 headline total because "automotive industry" reasonably stretches to cover motor-vehicle manufacturing broadly, but a reader drawing the line at cars-and-trucks-only would put this in its own bucket.

## What counted, and what didn't

This report started the same way this project's oil-and-gas report did: an automated keyword scan (`tooling/donor-keyword-scan.rb`) against every donor's name, employer, and occupation, then manual review of every match. The manual pass mattered even more here, because several of the most tempting keywords turned out to be near-total noise:

- **"tire" matched "RETIRED."** All 8,099 "tire" hits in this pass were someone's occupation field reading "RETIRED," not a tire company — over $557,000 of noise from a single bad keyword. Dropped entirely.
- **"gm" and "ford" as bare substrings are mostly surnames.** Dingman, Kingman (×2), Sigmond, Lankford, Weatherford (×2), Hargrove, Willson (via employer "Paradigm Home Health"), Wilson (via employer "Ewil Mgmt Co."), Crawford, and "Ford, Diann" (a retiree, no relation) all matched on nothing but spelling. So did the "Affordable Housing Tax Credit Coalition PAC," which contains "ford" inside "aFFORDable." None of these are in the total.
- **The disbursement side had its own surname problem.** Four Raptor PAC contributions *to other candidates' committees* — Crawford for Congress ($6,000 across two checks), Mark Alford for Congress ($5,000), Tedford for U.S. Congress ($5,000), and Citizens for John Rutherford ($2,000) — matched "ford" for the same reason, and a $263.91 event-ticket payment to something recorded as "State of Wexford" matched on the same substring. These are the Raptor PAC's own outbound political giving and an unrelated venue charge, not automotive spending, and are excluded.
- **A committee name coincidentally contains "nada."** TransCanada USA Services, Inc. PAC (TC PAC) — an energy pipeline company's PAC, likely already reflected in this project's oil-and-gas coverage — matched the "nada" fragment inside "TransCA**NADA**." Excluded.
- **Ronald Sewell — same surname, different industry, already counted elsewhere.** Ronald Sewell gave $10,800 across three checks in the 2026 cycle, and shares a surname with the dealer family. But his own filed occupation is "LANDMAN" (self-employed), and this exact donor and total already appear in this project's `2026-oil-and-gas.md` report under its Permian "landmen" roll call. Following that report's own scoping rule — trust the filer's stated occupation, not a surname — he's excluded here to avoid implying the auto-dealer Sewells and the landman Sewell are the same money.
- **Two matches flagged but not counted.**
  - **Meghan Sewell** gave $12,000 on the same date and to the same committee as Collin Sewell, but her own filing lists "SELF" / "HOMEMAKER" — no employer naming the dealer group. She may well be a family member (a spouse is a reasonable guess given the shared date and surname), but nothing in the FEC filing itself says so, so she's flagged rather than folded into the Sewell total.
  - **Scott Dueser** gave $1,000 on 2025-03-11, filed with the same transposed-field pattern as Canda Sewell above — employer "CEO," occupation "Sewell Family of Companies." But Scott Dueser is publicly identified as a longtime senior executive of **First Financial Bankshares**, an Abilene-based bank holding company — CEO/Chairman at the time of this contribution, since transitioned to Executive Chairman — with no findable public connection to the Sewell dealer group ([First Financial Bankshares proxy filings](https://www.sec.gov/Archives/edgar/data/36029/000119312526095645/ffin-20260306.htm)). His filing's city, Abilene, matches his known bank role, not Odessa where every other Sewell-company donor is listed. This reads like a data-entry mistake — possibly his row picking up text meant for an adjacent row during filing — rather than a real, undisclosed board seat. Flagged and excluded, not asserted as fact either way.
- **Two insurance/financial-services PACs matched on "automobile" but sell coverage, not cars.** State Farm Mutual Automobile Insurance Company Federal PAC ($2,000) and the United Services Automobile Association (USAA) Employee PAC ($1,000) are both insurers whose names happen to contain "Automobile." Neither is in the $41,500 headline total.
- **William Kliewer, filed as "AUTO DEALER INSURANCE EXEC" at BKCW LP** ($2,500), is a real Killeen, TX insurance agency (Bigham Kliewer Chapman & Watts) specializing in general property/casualty lines, including auto-dealer coverage — but insurance sold *to* auto dealers isn't the auto business itself ([BKCW Insurance](https://www.bkcw.com/)). Not included in the headline total; noted here for completeness.

The same donor-scoping rule this project has used before applies: only rows FEC's own `line_number_label` marks as "Contributions From Individuals" or "Contributions From Other Political Committees" count, never a "Transfers from authorized committees" row.

## Money going out: rental cars, a car wash, and a car payment

Scanning Schedule B (disbursements) with a sibling tool, `tooling/vendor-keyword-scan.rb`, for automotive vendor names turned up **$30,178.51** across 89 line items — nearly all on the principal committee, one on the JFC — small by comparison to the campaign's ~$8.08 million in total 2026-cycle itemized spending, but with one pattern worth a closer look.

### The car payment

Starting 2025-01-21, August Pfluger for Congress paid **$669.59** roughly monthly to **"LINCOLN FORD CREDIT,"** with nine such payments running through 2025-09-16. On **2025-10-20**, the committee paid **$1,004.62** to **"SEWELL FORD"** itself — the same Odessa Ford/Lincoln dealership whose managing partner, Paul Crump, is a $500 donor above. From **2025-11-07** onward the recurring payment to Lincoln Ford Credit steps up to **$975.03** a month, with an odd one-off $395.00 payment on 2025-11-24, then continuing monthly through **2026-06-05** — eight payments at the new amount. In all: **$15,226.17** across 19 payments from January 2025 through June 2026, every one of them tagged "Travel Expenses" in FEC's own spending category.

The timing — a lump payment to the dealership itself right as the recurring payment amount jumps — is consistent with a vehicle trade-in, refinance, or upgrade in October/November 2025, though the filings don't say so explicitly and this report doesn't guess further than what's filed. "LINCOLN FORD CREDIT" as a vendor name most likely refers to **Lincoln Automotive Financial Services**, Ford Motor Credit Company's captive financing arm for Lincoln-brand vehicles ([Ford Media Center](https://www.fromtheroad.ford.com/us/en/articles/2024/consumers--ford-credit--lincoln-automotive-financial-services-no)) — but the filing lists the recipient's city as San Angelo, TX (Pfluger's hometown, not Odessa where Sewell Ford is), and no exact company named "Lincoln Ford Credit" independently turned up in this session's searches, so treat that identification as a strong inference, not a confirmed fact.

**A recurring loan-style "car payment" is a different animal from a rental-car receipt.** Committees more commonly lease or rent vehicles for campaign use; making an ongoing payment toward what reads like a purchase or finance agreement raises the kind of personal-use question the FEC's own rules on campaign asset ownership exist to police. This report makes no claim that anything here is improper — the payments are disclosed exactly as filed, campaign funds paying for a "CAR PAYMENT"/"TRANSPORTATION" line coded "Travel Expenses" isn't inherently improper, and this project doesn't have the additional facts (title, ownership, post-campaign disposition) that would be needed to say more. It's flagged because the pattern itself is unusual enough to be worth a future look, not because the numbers show a violation.

### Rental cars and a car wash

The rest of the automotive disbursement total is more ordinary campaign travel:

| Vendor | Amount | Charges |
|---|---|---|
| Hertz | $5,752.06 | 15 charges, Dec 2024–Apr 2026, in Waco, Miami, Oklahoma City, DC, and DFW |
| Budget | $3,475.09 | 7 charges, filed under both "BUDGET RENT-A-CAR"/"BUDGET RENT A CAR" and "BUDGET CAR RENTAL" |
| Enterprise Rent-A-Car | $1,319.48 | 3 charges |
| Avis | $1,065.41 | 4 charges |
| Turo | $582.10 | 2 charges |
| National Car Rental | $586.51 | 1 charge, on the JFC rather than the principal committee |
| Campbell Concierge | $695.99 | 1 charge, described as "CAR RENTAL" — a smaller/regional service this report couldn't independently identify beyond the filing's own description |
| Amex "Premium Car Rental Protection" | $149.70 | 6 charges, a rental-insurance add-on rather than the rental itself |
| **Yates Car Wash & Detail Center** (Alexandria, VA) | $1,326.00 | 30 small recurring charges of $34–$52, March 2025–May 2026, filed alternately as "CAR MAINTENANCE" and "VEHICLE MAINTENANCE" |

Yates Car Wash & Detail Center sits in Alexandria, VA — across the Potomac from Washington, DC — suggesting routine upkeep on a DC-area vehicle, separate from whatever the Lincoln Ford Credit payments are financing in Texas.

## Takeaways

1. **Automotive is a minor industry in Pfluger's fundraising and spending, and that's itself worth saying plainly.** $41,500 out of $5.32 million in itemized 2026 receipts (0.78%) and $30,178.51 out of $8.08 million in itemized 2026 disbursements (0.37%) are nowhere near the roughly one-in-four-dollar share this project has already documented for oil and gas — a useful contrast, not a non-finding.
2. **The industry money that does exist is a tight, identifiable circle.** A single four-generation Odessa dealer family — the Sewells — accounts for $20,000 of the $41,500 (48%), all through the JFC.
3. **The campaign's own car spending tells a small story of its own.** A recurring "CAR PAYMENT" to a Ford-affiliated finance company, stepping up right after a lump payment to the same Odessa Ford dealership whose managing partner donates to the campaign, is a pattern this report flags for a future, deeper look rather than resolves here — now visible end-to-end (January 2025 through June 2026) directly in the FEC's processed export, with no data-gap reconstruction required.
4. **Manual review remains essential, not optional.** A single keyword — "tire" — would have inflated the receipts total by over half a million dollars if taken at face value, matching "RETIRED" 8,099 times. Surnames (Crawford, Kingman, Sigmond, Lankford, Weatherford, Wilson/Willson, Dingman, Hargrove) and a place name (Wexford) accounted for most of the rest of the raw keyword noise.
5. **One donor's filed identity doesn't match their public one, and one personal-disclosure aside brushes against this topic without belonging in it.** Scott Dueser's occupation field ties him to the Sewell dealer group, but everything publicly findable about him ties him to an unrelated Abilene bank instead. Separately, Pfluger's own March 2026 stock-purchase disclosures include Amerco (U-Haul's parent company) and Enterprise Products Partners (an oil-and-gas midstream company, already covered elsewhere) — neither is campaign committee money, so neither is counted in any total above, but both are close enough to this report's subject to be worth naming.

## Caveats

This is a keyword-and-manual-review exercise, not an FEC-assigned industry classification — there's no "automotive" checkbox on a Schedule A or B filing, and a donor's or vendor's free-text employer/occupation/description field can be blank, stale, or simply not descriptive enough to catch. A company or vendor with a name this report's keyword list didn't anticipate would not appear here even if it belongs. Every dollar figure and file:line citation above was checked against the source CSV before publication. Vendor and donor identification (e.g., "Lincoln Ford Credit," the Sewell Family of Companies, BKCW/Kliewer, Scott Dueser) relied on web search where the filing itself didn't make the connection obvious, and is flagged as inference rather than fact where that search came up short (Campbell Concierge remains unidentified). As always: legal, fully disclosed campaign contributions and disbursements are not evidence of anything improper by themselves — this report counts and traces the money and leaves judgment about what it means to the reader.

---

# Methodology & AI Transparency Appendix

*(This section is explicitly excluded from the report's word-count limit.)*

**Report generated:** 2026-08-16, by Claude Sonnet 5 (Anthropic), running as the "Claude Code" CLI agent inside a VS Code extension session, on behalf of user Tod Beardsley.

**Data sources:**

- FEC Schedule A (receipts) and Schedule B (disbursements) exports for August Pfluger's four known 2026-cycle committees, stored under `tx-11/august-pfluger/fec/`:
  - `C00719294` — August Pfluger for Congress (principal committee)
  - `C00749481` — Raptor PAC (leadership PAC)
  - `C00753913` — Pfluger Victory Fund (joint fundraising committee)
  - `C00840033` — PFriends of Pfluger (a second, much smaller joint fundraising committee; no automotive-related activity found in either scan)
- All four committees' raw `efile-*.csv` submissions were scanned for the gap window past each committee's processed `schedule_a`/`schedule_b` export, via `--include-efile-gap` on both scan tools. None of the four committees triggered an `EFILE COVERAGE WARNING` on this run — each committee's processed export already covers everything its raw efile files contain, so this report's totals rest entirely on processed data; the efile-gap scan returned zero additional rows.
- House Ethics Committee (personal financial disclosure) data was checked but not used in the final report's totals. A keyword scan of all eight PDFs under `house-ethics/` (using `pdf-reader` directly, keywords: ford, gm, toyota, honda, nissan, tesla, chrysler, stellantis, chevrolet, dealership, automotive, automobile, hertz, avis, enterprise, budget, u-haul, uhaul, amerco, rivian, polaris, carmax, autonation) found two hits, both in a single March 2026 Periodic Transaction Report: **Amerco** (U-Haul's parent holding company, a $15,001–$50,000 new stock purchase) and **Enterprise Products Partners** (an oil-and-gas midstream company of the same name as Enterprise Rent-A-Car, coincidentally — also a $15,001–$50,000 new purchase, and already covered by this project's oil-and-gas report). Neither is campaign committee money, which is this report's actual subject, so neither affects any total above; both are named in Takeaway 5 for completeness.
- Report scoped strictly to the 2026 two-year FEC cycle (`two_year_transaction_period` = 2026 for schedule_a/schedule_b rows).

**Tooling used:**

- `tooling/analyze-candidate.rb` (unmodified) — run first to get baseline totals and confirm `EFILE COVERAGE WARNING` state. Command run:
  ```
  ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics --cycle 2026 --top 40
  ```
  This run's "RECEIPTS (itemized, non-memo, donor rows only)" and "DISBURSEMENTS (itemized, non-memo)" committee subtotals are the source for the $5,317,758.43 total-receipts and $8,081,363.33 total-disbursements figures used to compute this report's percentages.
- `tooling/donor-keyword-scan.rb` (unmodified) — used for the receipts side. Command run:
  ```
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "Automotive=automotive,automobile,auto dealer,auto group,dealership,car dealer,dealer group,motors,ford,gm,general motors,toyota,honda,nissan,hyundai,kia,subaru,volkswagen,bmw,mercedes,lexus,mazda,mitsubishi,chevrolet,chevy,dodge,cadillac,buick,gmc,jeep,chrysler,stellantis,tesla,rivian,polaris,national automobile dealers,nada,carmax,autonation,sewell,car sales,auto sales,tire,valvoline,jiffy lube,napa,autozone,o'reilly,advance auto,pep boys,firestone,goodyear,mechanic,auto repair,auto body"
  ```
  Every match (8,207 rows) was reviewed by hand; see "What counted, and what didn't" for which keywords were kept, dropped, or excluded and why.
- `tooling/vendor-keyword-scan.rb` (unmodified) — used for the disbursements side. Command run:
  ```
  ruby tooling/vendor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "Automotive=hertz,avis,enterprise rent,budget rent,national car rental,alamo rent,u-haul,uhaul,car rental,vehicle lease,auto lease,dealership,ford,chevrolet,chevy,toyota,honda,nissan,jeep,dodge,chrysler,gmc,cadillac,buick,tesla,rivian,jiffy lube,valvoline,discount tire,firestone,goodyear,pep boys,autozone,o'reilly auto,advance auto,napa auto,carmax,autonation,vehicle purchase,vehicle maintenance,auto repair,car wash,tire,oil change,mechanic,sewell,car payment,turo,rent-a-car,rent a car"
  ```
  Every match (94 rows) was reviewed by hand.
- A one-off Ruby script (not saved) used `pdf-reader` directly to text-search all eight House Ethics PDFs for automotive keywords, per the Data sources note above.
- Follow-up Ruby one-liners (not saved as tooling, single-use rollups) computed the per-vendor/per-donor subtotals, brand groupings, and percentage-of-total figures cited throughout this report, from the JSON output the two scan tools produced.

**Verification performed:** every dollar figure and file:line citation in the body of this report was checked against the source CSV directly before publication. The Ronald Sewell exclusion was cross-checked against this project's own `2026-oil-and-gas.md` report, which independently reports the identical $10,800/three-check total for the same donor under "Landmen" — agreement between the two increases confidence that neither report has double-counted or mis-attributed him. The car-payment total ($15,226.17 across 19 payments) was reconciled against this report's own prior version, which had reconstructed part of the same figure through an efile-gap workaround no longer needed now that the processed export covers the full window natively — both arrive at the identical total, which increases confidence in the figure.

**Web research:** conducted strictly to verify the *nature* of ambiguous donors, companies, and vendors (what industry they're actually in, or whether a named entity is identifiable at all), never to establish or adjust any dollar figure — every dollar amount in this report comes from the local FEC CSV data only. Searches this session covered: Collin Sewell and the Sewell Family of Companies, BKCW LP / Bigham Kliewer Chapman & Watts, Scott Dueser's current public role at First Financial Bankshares, Lincoln Automotive Financial Services / Ford Motor Credit, and "Campbell Concierge" (no confirmed identification found).

**Model configuration:** default Claude Code agent settings for this session; no unusual temperature/token-limit configuration was requested or applied by the user.

**Verbatim prompt this report was generated from:**

> CANDIDATE: `August Pfluger`
> DISTRICT: `TX-11`
> CYCLE: `2026`
>
> Using the rules in this repo's top-level README.md, and following the style of tx-11/august-pfuger/2026-oil-and-gas.md, write a report detailing any automotive industry contributions or disbursements August Pfluger of TX-11 is involved in. You may use normal web searches to verify automotive industry things, especially donor employment.
>
> File this under tx-11/august-pfluger/reports/2026-automotive.md.

> [mid-session follow-up] Be sure to include efile data.

**Limitations and things a human should double-check before citing this report further:**

- This is a single-cycle (2026 cycle) snapshot of both receipts and disbursements — it says nothing about automotive-industry giving or spending in prior Pfluger cycles, since this repository doesn't yet have comparable multi-cycle data collected.
- Keyword matching plus manual review is a blunt instrument on the front end, in both directions: it over-matched badly on generic substrings ("tire" inside "retired," "ford"/"gm" inside ordinary surnames) and would just as easily under-match a real automotive donor or vendor whose name this report's keyword list didn't anticipate.
- The "Lincoln Ford Credit" identification and the interpretation of the October 2025 Sewell Ford payment as a possible vehicle swap/refinance are this report's best read of the filed data, not confirmed facts — a human with access to the campaign's own records (or a FOIA-style records request) could confirm or correct either.
- No claim is made that any contribution or disbursement here exceeds a legal limit, violates FEC personal-use rules, or otherwise breaks FEC rules — nothing in this report suggests that on its own, and it does not attempt to check.
