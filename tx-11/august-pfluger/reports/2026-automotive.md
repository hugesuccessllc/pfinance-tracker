# TX-11: August Pfluger — The Automotive Industry, on Both Sides of the Ledger

*A look at where car dealers, automakers, and rental-car companies show up in August Pfluger's 2026-cycle money — both money coming in from the industry, and money the campaign itself spends on cars.*

## The short version

Automotive money is a minor character in August Pfluger's 2026-cycle fundraising compared to, say, oil and gas (see this project's companion report, `2026-oil-and-gas.md`) — but it shows up on **both sides of the ledger**, and the two sides connect. On the receipts side, **$34,000** of itemized 2026-cycle donor money traces to the auto industry: a four-generation West Texas car-dealer family (the Sewells, who own Sewell Ford Lincoln in Odessa and nine other brands under "The Sewell Family of Companies"), plus PAC checks from General Motors, Toyota, the National Automobile Dealers Association, and Polaris (ATVs/snowmobiles/Indian Motorcycles). That's **0.65%** of the $5,257,758.43 in itemized donor receipts recorded across Pfluger's three 2026-cycle committees.

On the disbursement side, the campaign's principal committee spent **$28,571.81** — **0.35%** of $8,076,363.33 in itemized 2026 spending — on automotive vendors: rental cars, a car wash, and, most notably, a **recurring monthly car payment to Lincoln Ford Credit that appears to be financing a vehicle rather than renting one**, plus a one-time $1,004.62 payment to **Sewell Ford** itself — the same Odessa dealership whose managing partner is a Pfluger donor.

Both totals are small next to the oil-and-gas numbers this project has already documented for Pfluger, and that's itself the honest finding: automotive isn't a defining industry in his fundraising the way West Texas oil is. What's here is worth a look anyway — a durable, family-run dealer group giving five figures, a car-payment pattern in the spending data that's unusual enough to flag, and one instance where a donor's filed occupation didn't match their public biography at all.

## Money coming in: the Sewells and the industry PACs

### The Sewell Family of Companies — $20,000

**Collin Sewell**, filed as "President" at "THE SEWELL FAMILY OF COMPANIES," gave **$12,000** on 2025-12-22 (`fec/C00753913/schedule_a-2026-07-20T20_08_10.csv:2927`). Public reporting confirms Collin Sewell is president/CEO of the Sewell Family of Companies, a fourth-generation Odessa, TX auto-dealer group tracing back to 1911 that today operates Ford, Lincoln, BMW, Cadillac, Buick, GMC, Chrysler, Dodge, Jeep, RAM, and Chevrolet dealerships out of Odessa — inside TX-11 ([TheOrg](https://theorg.com/org/sewell-family-of-companies/org-chart/collin-sewell); [KWES NewsWest 9](https://www.newswest9.com/article/life/heartwarming/sewell-family-of-companies-president-named-2024-citizen-of-the-year-in-odessa/513-cb0c5527-e2c9-40b7-875d-b28809af74b7)).

**Canda Sewell** gave **$7,500** across two checks — $5,000 on 2026-02-17 (`:2799`) and $2,500 on 2026-02-13 (`:2596`) — filed as CEO of the same company. Worth flagging as-filed: both of Canda Sewell's rows have the employer and occupation fields transposed in the raw data (`contributor_employer` reads "CEO," `contributor_occupation` reads "SEWELL FAMILY OF COMPANIES"), a filer-side data-entry swap rather than an error in this report's reading of it — the meaning is unambiguous either way.

**Paul Crump Jr.**, Managing Partner at **Sewell Ford Lincoln** specifically (the Odessa store, not the parent holding company), gave **$500** on 2025-06-30 (`:2276`).

All three gifts went to the **Pfluger Victory Committee** (the JFC), none to the principal campaign or Raptor PAC.

### Industry PACs — $8,500

| PAC | Amount | Committee | Dates |
|---|---|---|---|
| Toyota Motor North America, Inc. PAC | $3,500 | C00719294 | $2,500 on 2025-03-19 (`fec/C00719294/schedule_a-2026-07-20T23_36_44.csv:38576`); $1,000 on 2026-03-17 (`:38252`) |
| National Automobile Dealers Association PAC | $5,000 | C00753913 | $2,500 on 2025-08-01, filed as "...POLITICAL ACTION COMMITTEE" (`fec/C00753913/schedule_a-2026-07-20T20_08_10.csv:2656`); $2,500 on 2026-02-17, filed as "...PAC" (`:2611`) — same committee, C00040998, filed under two slightly different name strings |
| General Motors Company PAC (GM PAC) | $2,500 | C00719294 | 2025-05-30 (`fec/C00719294/schedule_a-2026-07-20T23_36_44.csv:38618`) |

### Adjacent, not core — Polaris Industries — $3,000

**Polaris Industries Political Participation Program** gave $1,000 on 2025-06-30 (`fec/C00753913/schedule_a-2026-07-20T20_08_10.csv:2433`) and $2,000 on 2026-03-03 (`:2534`). Polaris makes ATVs, snowmobiles, and Indian Motorcycles — powersports, not passenger-car manufacturing. It's included in the $34,000 headline total because "automotive industry" reasonably stretches to cover motor-vehicle manufacturing broadly, but a reader drawing the line at cars-and-trucks-only would put this in its own bucket.

## What counted, and what didn't

This report started the same way this project's oil-and-gas report did: an automated keyword scan (`tooling/donor-keyword-scan.rb`, already built for that report) against every donor's name, employer, and occupation, then manual review of every match. The manual pass mattered even more here, because several of the most tempting keywords turned out to be near-total noise:

- **"tire" matched "RETIRED."** Every one of >7,900 "tire" hits was someone's occupation field reading "RETIRED," not a tire company. Dropped entirely.
- **"mema" matched "HOMEMAKER."** Same problem, different word — dropped entirely.
- **"gm" and "ford" as bare substrings are mostly surnames.** "Sigmond," "Kingman," "Weatherford," "Crawford," "Lankford," "Hargrove," "Dingman," "Ford, Diann" (a retiree, no relation), and the "Affordable Housing Tax Credit Coalition PAC" all matched on nothing but spelling. So did **"Charley" Ohlen** matching "harley." None of these are in the total.
- **A quirk in the disbursement scan surfaced a genuinely different problem**: four Raptor PAC contributions *to other candidates' committees* — Crawford for Congress, Mark Alford for Congress, Tedford for U.S. Congress, and Citizens for John Rutherford — matched "ford" for the same surname-coincidence reason. These are Raptor PAC's own outbound political giving, unrelated to cars in any sense, and are excluded.
- **Ronald Sewell — same surname, different industry, already counted elsewhere.** Ronald Sewell gave $10,800 across three checks in the 2026 cycle (`:2800`, `:2687`, `:2597`), and shares a surname with the dealer family. But his own filed occupation is "LANDMAN" (self-employed), and this exact donor and exact total already appear in this project's `2026-oil-and-gas.md` report under its Permian "landmen" roll call. Following that report's own scoping rule — trust the filer's stated occupation, not a surname — he's excluded here to avoid implying the auto-dealer Sewells and the landman Sewell are the same money.
- **Two matches flagged but not counted.**
  - **Meghan Sewell** gave $12,000 on the same date and to the same committee as Collin Sewell (`:2928`), but her own filing lists "SELF" / "HOMEMAKER" — no employer naming the dealer group. She may well be a family member (a spouse is a reasonable guess given the shared date and surname), but nothing in the FEC filing itself says so, so she's flagged rather than folded into the Sewell total.
  - **Scott Dueser** gave $1,000 on 2025-03-11 (`:2356`), filed with the same transposed-field pattern as Canda Sewell above — employer "CEO," occupation "Sewell Family of Companies." But Scott Dueser is publicly identified as Chairman/CEO of **First Financial Bankshares**, an Abilene-based bank holding company, with no findable public connection to the Sewell dealer group ([First Financial Bank](https://ffin.com/en-us/about/officers-directors/f-scott-dueser/)). His filing's city, Abilene, matches his known bank role, not Odessa where every other Sewell-company donor is listed. This reads like a data-entry mistake — possibly his row picking up text meant for an adjacent row during filing — rather than a real, undisclosed board seat. Flagged and excluded, not asserted as fact either way.
- **Trucking/freight is a different industry.** National Tank Truck Carriers Inc. PAC ($1,000) and Parrish Trucking (small recurring amounts, self-employed owner) are motor-carrier/freight businesses, not automotive manufacturing or retail. Excluded, same logic the oil-and-gas report used to exclude SpaceX for matching "exploration."
- **One match included on weaker footing, flagged rather than folded in.** William Kliewer, filed as "AUTO DEALER INSURANCE EXEC" at **BKCW LP** ($2,500, `fec/C00719294/schedule_a-2026-07-20T23_36_44.csv:38573`), is confirmed as a real Killeen, TX insurance agency (Bigham Kliewer Chapman & Watts) specializing in general property/casualty lines including auto-dealer coverage ([BKCW Insurance](https://www.bbb.org/us/tx/austin/profile/insurance-agency/bkcw-lp-0825-43297)). That's insurance sold *to* auto dealers, not the auto business itself — closer to the "gas utility PAC" judgment call in the oil-and-gas report than to a clean match. Not included in the $34,000 headline total; noted here for completeness.

The same donor-scoping rule this project has used before applies: only rows FEC's own `line_number_label` marks as "Contributions From Individuals" or "Contributions From Other Political Committees" count, never a "Transfers from authorized committees" row.

## Money going out: rental cars, a car wash, and a car payment

Scanning Schedule B (disbursements) with a sibling tool, `tooling/vendor-keyword-scan.rb`, for automotive vendor names turned up **$28,571.81** across 78 line items on the principal committee (and one on the JFC) — small by comparison to the campaign's ~$8.08 million in total 2026-cycle itemized spending, but with one pattern worth a closer look.

### The car payment

Starting 2025-01-21, August Pfluger for Congress paid **$669.59** roughly monthly to **"LINCOLN FORD CREDIT"**, described on the filing as "CAR PAYMENT" (`fec/C00719294/schedule_b-2026-07-20T19_59_25.csv:7810` through `:7818`, nine payments through 2025-09-16). On **2025-10-20**, the committee paid **$1,004.62** to **"SEWELL FORD"** itself, described as "TRANSPORTATION" (`:7993`) — the same Odessa Ford/Lincoln dealership whose managing partner, Paul Crump, is a $500 donor above. From **2025-11-07** onward the recurring "CAR PAYMENT" to Lincoln Ford Credit steps up to **$975.03** a month (`:7962`, an odd one-off $395.00 on 2025-11-24 at `:7552`, then `:7963`–`:7966` for Dec 2025–Mar 2026, and three more months — Apr, May, June 2026 — recovered from the raw efile data that hadn't yet reached FEC's processed export: `fec/C00719294/efile-2026-07-19T17_25_08.csv:818`, `:649`, `:533`). In all: **$15,226.17** across 19 payments from January 2025 through June 2026, every one of them tagged "Travel Expenses" in FEC's own spending category.

The timing — a lump payment to the dealership itself right as the recurring payment amount jumps — is consistent with a vehicle trade-in, refinance, or upgrade in October/November 2025, though the filings don't say so explicitly and this report doesn't guess further than what's filed. "LINCOLN FORD CREDIT" as a vendor name most likely refers to **Lincoln Automotive Financial Services**, Ford Motor Credit Company's captive financing arm for Lincoln-brand vehicles ([Ford Media Center](https://media.ford.com/content/fordmedia/fna/us/en/news/2024/11/14/consumers--ford-credit--lincoln-automotive-financial-services-no.html)) — but the filing lists the recipient's city as San Angelo, TX (Pfluger's hometown, not Odessa where Sewell Ford is), and no exact company named "Lincoln Ford Credit" independently turned up in this session's searches, so treat that identification as a strong inference, not a confirmed fact.

**A recurring loan-style "car payment" is a different animal from a rental-car receipt.** Committees more commonly lease or rent vehicles for campaign use; making an ongoing payment toward what reads like a purchase or finance agreement raises the kind of personal-use question the FEC's own rules on campaign asset ownership exist to police. This report makes no claim that anything here is improper — the payments are disclosed exactly as filed, campaign funds paying for a "CAR PAYMENT"/"TRANSPORTATION" line coded "Travel Expenses" isn't inherently improper, and this project doesn't have the additional facts (title, ownership, post-campaign disposition) that would be needed to say more. It's flagged because the pattern itself is unusual enough to be worth a future look, not because the numbers show a violation.

### Rental cars and a car wash

The rest of the automotive disbursement total is more ordinary campaign travel:

| Vendor | Amount | Trips/charges |
|---|---|---|
| Hertz | $4,401.16 | 12 charges, Dec 2024–Apr 2026, in Waco, Miami, Oklahoma City, DC, and DFW (`fec/C00719294/schedule_b-2026-07-20T19_59_25.csv:7922` and others; DFW charge from efile, `efile-2026-07-19T17_25_08.csv:800`) |
| Budget | $3,475.09 | 7 charges, filed under both "BUDGET RENT-A-CAR"/"BUDGET RENT A CAR" and "BUDGET CAR RENTAL" (`:7782` and others) |
| Enterprise Rent-A-Car | $1,319.48 | 3 charges (`:7522`, `:7803`; one from efile, `efile-...csv:552`) |
| Avis | $1,065.41 | 4 charges, including three from the raw efile gap in June 2026 (`:7327`; `efile-...csv:450`, `:445`, `:486`) |
| Turo | $582.10 | 2 charges (`:7731`, `:6753`) |
| National Car Rental | $586.51 | 1 charge, on the JFC rather than the principal committee (`fec/C00753913/schedule_b-2026-07-20T20_08_35.csv:901`) |
| Campbell Concierge | $695.99 | 1 charge, described as "CAR RENTAL" (`:7836`) — a smaller/regional service this report couldn't independently identify beyond the filing's own description |
| Amex "Premium Car Rental Protection" | $49.90 | 2 charges, a rental-insurance add-on rather than the rental itself (`efile-...csv:671`, `:580`) |
| **Yates Car Wash & Detail Center** (Alexandria, VA) | $1,170.00 | 27 small recurring charges of $37–$52, March 2025–May 2026, filed alternately as "CAR MAINTENANCE" and "VEHICLE MAINTENANCE" (`:6693` and others) |

Yates Car Wash & Detail Center sits in Alexandria, VA — across the Potomac from Washington, DC — suggesting routine upkeep on a DC-area vehicle, separate from whatever the Lincoln Ford Credit payments are financing in Texas.

## Takeaways

1. **Automotive is a minor industry in Pfluger's fundraising, and that's itself worth saying plainly.** $34,000 out of $5.26 million in itemized 2026 receipts (0.65%) is nowhere near the roughly one-in-four-dollar share this project has already documented for oil and gas — a useful contrast, not a non-finding.
2. **The industry money that does exist is a tight, identifiable circle.** A single four-generation Odessa dealer family — the Sewells — accounts for $20,000 of the $34,000 (59%), all through the JFC.
3. **The campaign's own car spending tells a small story of its own.** A recurring "CAR PAYMENT" to a Ford-affiliated finance company, stepping up right after a lump payment to the same Odessa Ford dealership whose managing partner donates to the campaign, is a pattern this report flags for a future, deeper look rather than resolves here.
4. **Data-integrity work mattered more than the dollar totals.** Two keywords ("tire," "mema") that looked reasonable on paper turned out to match "RETIRED" and "HOMEMAKER" almost universally — a reminder that this report's method (broad keyword net, then full manual review) only works if every match is actually checked, not just the ones large enough to look interesting.
5. **One donor's filed identity doesn't match their public one.** Scott Dueser's occupation field ties him to the Sewell dealer group, but everything publicly findable about him ties him to an unrelated Abilene bank instead — flagged rather than resolved, because this report can't determine which is true from the data on hand.

## Caveats

This is a keyword-and-manual-review exercise, not an FEC-assigned industry classification — there's no "automotive" checkbox on a Schedule A or B filing, and a donor's or vendor's free-text employer/occupation/description field can be blank, stale, or simply not descriptive enough to catch. A company or vendor with a name this report's keyword list didn't anticipate would not appear here even if it belongs. Every dollar figure and file:line citation above was checked against the source CSV before publication. Vendor name identification (e.g., "Lincoln Ford Credit," "Campbell Concierge") relied on web search where the filing itself didn't make the connection obvious, and is flagged as inference rather than fact where that search came up short. As always: legal, fully disclosed campaign contributions and disbursements are not evidence of anything improper by themselves — this report counts and traces the money and leaves judgment about what it means to the reader.

---

# Methodology & AI Transparency Appendix

*(This section is explicitly excluded from the report's word-count limit.)*

**Report generated:** 2026-08-06T23:57:52Z (2026-08-06, 6:57 PM Central Daylight Time). By Claude Sonnet 5 (Anthropic), running as the "Claude Code" CLI agent inside a VS Code extension session, on behalf of user Tod Beardsley.

**Data sources:**

- FEC Schedule A (receipts) and Schedule B (disbursements) exports for August Pfluger's three known 2026-cycle committees, stored under `tx-11/august-pfluger/fec/`:
  - `C00719294` — August Pfluger for Congress (principal committee)
  - `C00749481` — Raptor PAC (leadership PAC)
  - `C00753913` — Pfluger Victory Committee (joint fundraising committee)
- All three committees' raw `efile-*.csv` submissions (receipts- and disbursement-shaped) were scanned for the gap window past each committee's processed `schedule_a`/`schedule_b` export, per instruction mid-session to be sure efile data was included.
- No House Ethics Committee (personal financial disclosure) data was used in the final report. It was checked — a quick scan of all eight PDFs under `house-ethics/` for automotive keywords (Ford, GM, Toyota, Honda, Nissan, Tesla, Chrysler, Stellantis, Chevrolet, "Dealership," "Automotive," "Automobile") returned zero hits — but personal financial disclosures don't cover campaign committee contributions or disbursements, which is this report's actual subject.
- Report scoped strictly to the 2026 two-year FEC cycle (`two_year_transaction_period` = 2026 for schedule_a/schedule_b rows; calendar-year approximation for efile-gap rows, per existing tooling convention).

**Tooling used:**

- `tooling/analyze-candidate.rb` (pre-existing, unmodified) — run first to get baseline totals and confirm `EFILE COVERAGE WARNING` state. Command run:
  ```
  ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics --cycle 2026 --top 40
  ```
  Confirmed processed data for the principal committee and JFC both end 2026-03-31, with raw efile data extending to 2026-06-30/2026-06-26 respectively — already folded into this run's own totals. This run's "RECEIPTS (itemized, non-memo, donor rows only)" and "DISBURSEMENTS (itemized, non-memo)" committee subtotals are the source for the $5,257,758.43 total-receipts and $8,076,363.33 total-disbursements figures used to compute this report's percentages.
- `tooling/donor-keyword-scan.rb` (pre-existing, unmodified, built for the prior oil-and-gas report) — used for the receipts side. Commands run (in order, refining the keyword list after reviewing each pass's matches):
  ```
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "Automotive=automotive,automobile,auto dealer,auto group,...,valvoline"
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "DealerCheck=dealer,dealership,motors,ford,gm,honda,...,napa"
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "Automotive2=stellantis,american honda,nissan north america,...,forest river"
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "AutoBrands=chevrolet,chevy,dodge,cadillac,buick,gmc,jeep,tesla,rivian,honda,nissan,hyundai,kia,subaru,volkswagen,bmw,mercedes,lexus,mazda,mitsubishi,stellantis,carmax,autonation,sewell,car dealer,vehicle,dealership,mechanic,automotive,dealer group"
  ```
  The full keyword lists are longer than shown above; see the "What counted, and what didn't" section for which individual keywords were kept, dropped, or excluded and why. Every match across all four passes was reviewed by hand before anything was counted.
- `tooling/vendor-keyword-scan.rb` — used for the disbursements side, **with a bug fixed in it during this report's construction** (see below). Command run (after the fix):
  ```
  ruby tooling/vendor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "Automotive=hertz,avis,enterprise rent,budget rent,national car rental,alamo rent,u-haul,uhaul,car rental,vehicle lease,auto lease,dealership,ford,chevrolet,chevy,toyota,honda,nissan,jeep,dodge,chrysler,gmc,cadillac,buick,tesla,rivian,jiffy lube,valvoline,discount tire,firestone,goodyear,pep boys,autozone,o'reilly auto,advance auto,napa auto,carmax,autonation,vehicle purchase,vehicle maintenance,auto repair,car wash,tire,oil change,mechanic"
  ```
- **Bug found and fixed in `tooling/vendor-keyword-scan.rb`:** the first run of the command above, with `--cycle 2026 --include-efile-gap` together, silently returned zero efile-gap rows. Root cause: the shared row-scan cycle filter compared `row["two_year_transaction_period"]` against `--cycle`, but the raw disbursement-shaped `efile-*.csv` has no such column at all (only the processed `schedule_b-*.csv` does) — so the comparison always failed for efile-gap rows and `next` always fired, discarding the entire gap window with no warning. This is exactly the kind of silent-gap bug this project's `analyze-candidate.rb` already has a fix and header gotcha for (its own efile-gap logic approximates cycle by calendar year for rows missing the field) — `donor-keyword-scan.rb`'s sibling receipts-side logic already had the same calendar-year fallback for its own efile-gap path, but `vendor-keyword-scan.rb`'s equivalent disbursements-side path never got the same fix when it was written. Fixed in place: the cycle filter now falls back to comparing the row's calendar year (from `disbursement_date`) against `--cycle`/`--cycle - 1` whenever `two_year_transaction_period` is blank, matching the other two tools' behavior. Documented as a dated header comment in the tool itself, not just here, per this project's standing rule that data-integrity fixes live with the code they explain. Confirmed fixed: re-running the same command after the fix recovered exactly the three April–June 2026 "LINCOLN FORD CREDIT" efile-gap payments (among other efile-gap rows) that the unfixed version had silently dropped — those three payments account for $2,925.09 of this report's $15,226.17 Lincoln Ford Credit/Sewell Ford figure.
- Follow-up Python one-liners (not saved as tooling, single-use rollups) computed the per-vendor/per-donor subtotals, brand groupings, and percentage-of-total figures cited throughout this report, from the JSON output the two scan tools produced.
- A one-off Ruby script (not saved) used `pdf-reader` to text-search all eight House Ethics PDFs for automotive keywords, confirming zero hits before this report proceeded on FEC data alone.

**Verification performed:** every dollar figure and file:line citation in the body of this report was checked against the source CSV directly before publication. The Ronald Sewell exclusion was cross-checked against this project's own `2026-oil-and-gas.md` report, which independently reports the identical $10,800/three-check total for the same donor under "Landmen" — agreement between the two increases confidence that neither report has double-counted or mis-attributed him.

**Web research:** conducted strictly to verify the *nature* of ambiguous donors, companies, and vendors (what industry they're actually in, or whether a named entity is identifiable at all), never to establish or adjust any dollar figure — every dollar amount in this report comes from the local FEC CSV data only. Searches covered: Sewell Ford Lincoln (Odessa, TX), the Sewell Family of Companies and Collin Sewell's role there, BKCW LP / Bigham Kliewer Chapman & Watts, Scott Dueser's public role at First Financial Bankshares, "Lincoln Ford Credit" and Lincoln Automotive Financial Services / Ford Motor Credit, and "Campbell Concierge" (no confirmed identification found for the last one).

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
- Keyword matching plus manual review is a blunt instrument on the front end, in both directions: it over-matched badly on generic substrings ("tire" inside "retired," "mema" inside "homemaker," "ford"/"gm" inside ordinary surnames) and would just as easily under-match a real automotive donor or vendor whose name this report's keyword list didn't anticipate.
- The "Lincoln Ford Credit" identification and the interpretation of the October 2025 Sewell Ford payment as a possible vehicle swap/refinance are this report's best read of the filed data, not confirmed facts — a human with access to the campaign's own records (or a FOIA-style records request) could confirm or correct either.
- No claim is made that any contribution or disbursement here exceeds a legal limit, violates FEC personal-use rules, or otherwise breaks FEC rules — nothing in this report suggests that on its own, and it does not attempt to check.
