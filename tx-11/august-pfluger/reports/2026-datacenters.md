# TX-11: August Pfluger — Data Center & AI Money in the 2026 Receipts

*A look at exactly which of August Pfluger's 2026-cycle donors — people and companies — trace to the data center and artificial intelligence industry, with a receipt for every dollar. This is a revision of an earlier version of this report; see "What changed since the last version" below for why the number moved.*

## The short version

Of the **$5,257,758.43** in itemized donor receipts recorded across August Pfluger's three 2026-cycle committees, this report traces **$125,500.00** — **2.39%** — to donors connected to the data center and AI industry, once the industry is defined to include not just cloud/hardware companies but the two industries actually building AI's physical footprint right now: **telecom and cable carriers laying the fiber that connects data centers ($51,000)** and **electric utilities racing to build the power plants that run them ($41,500)**. Add in cloud/hardware vendor PACs ($16,500), two named individuals who work at an AI lab ($5,500), one AI-defense-tech PAC ($5,000), one Houston data-center power executive ($3,500), and one government AI-cloud contractor's PAC ($2,500), and that's the full $125,500.

That's still a small share of Pfluger's money — 2.39 cents of every itemized dollar, versus the roughly quarter of every dollar this project's companion oil-and-gas report traced to that industry. Pfluger represents West Texas, and Permian Basin operators still dominate his donor list by a wide margin. But it's nearly **five times** the $26,000 the earlier version of this report found, and the shape of the finding changed along with the number: the earlier version looked only at companies with an obvious AI-industry name (Nvidia, Microsoft, Dell) and missed the two industries where the AI boom is actually showing up in political money in 2025–2026 — telecom carriers selling hyperscalers fiber, and power utilities signing multi-gigawatt deals to keep AI data centers running.

## What changed since the last version

The prior version of this report (2026-07-29) scanned for cloud, hardware, and AI-native company names and found $26,000. A reader supplied a list of contributions their own research had surfaced, most of them from telecom and cable PACs (AT&T, Verizon, Charter, Cox, Comcast) that weren't in the original keyword list at all, plus one electric-utility PAC (American Electric Power). That list prompted this re-run — expanded keyword groups, not a wholesale rewrite of the approach — and its own numbers didn't survive review unchanged (see "Reconciling against the seed list" below), but it was right that the report's industry definition was too narrow. Three things changed as a result:

1. **Two new keyword groups were added and one was extended.** "Telecom, Cable & Network" (AT&T, Verizon, Charter, Cox, Comcast, T-Mobile, Ericsson, and a handful of others that returned no matches) and "Electric Utility & AI Power Demand" (American Electric Power, Vistra, Southern Company, Constellation, Entergy, NextEra, Xcel, PG&E, and others) are both new. A "Gov Cloud/Defense IT" group (Leidos, SAIC, Booz Allen, CACI) was added and caught one match. The original cloud/hardware/AI-native group is unchanged.
2. **A real bug in the scanning tool got fixed.** While chasing why the seed list's American Electric Power donation wasn't showing up in a re-run of the *existing* keyword group, this report's research found that `tooling/donor-keyword-scan.rb`'s efile-gap logic was silently invisible to every PAC/committee-type donor in the not-yet-processed filing window — a bug, not a judgment call, now fixed and covered by a regression test. See "A tooling bug this report found and fixed" below; it added real money to every group, not just the new ones.
3. **The seed list itself needed reconciling, not just adopting.** Several of its rows turned out to be the same contribution counted more than once (FEC's own JFC earmark-echo mechanism, not an SME error — see below). The corrected picture is smaller than the seed list implied but still much larger than the original report found.

## The people: two AI-lab employees, one AI-defense PAC, one data-center-power executive

- **Peter Lofgren**, listed as **Member of Technical Staff at Anthropic** — the AI lab that makes Claude, the model used to research and draft this report — gave **$5,000** to the Pfluger Victory Committee on 2026-03-13 (`fec/C00753913/schedule_a-2026-07-20T20_08_10.csv:2798`). A second Anthropic donor, **Jared Powell**, listed as **Government Affairs at Anthropic PBC**, gave **$500** on 2025-11-19 (`:2213`). Combined, **$5,500** traces to employees of the company that makes the tool this report was written with — disclosed in its own section below, not buried.
- **Saronic Technologies Inc PAC** gave **$5,000** (`:2814`). Saronic is an Austin-based defense startup building AI-powered autonomous naval vessels for the U.S. Navy — genuinely an AI company, but one whose product is uncrewed ships, not cloud compute or data centers.
- **Ryan Castleman**, CEO of **OCIS Intelligent Energy**, gave **$3,500** (`:2726`). OCIS is a Houston company that develops hyperscale data-center sites and their on-site power — a minimum of 300 MW of gas-fired generation plus battery storage per site, per the company's own materials — the single closest match in this report to "the data center industry" in a literal, physical-infrastructure sense.

## Cloud, hardware & AI-native company PACs — $16,500

| PAC / Company | Amount | What it is |
|---|---|---|
| Dell Technologies, Inc. PAC | $7,500 (2 checks: $5,000 + $2,500) | Server and infrastructure vendor; sells the physical racks (its "AI Factory" line, built with Nvidia) that fill AI data centers |
| Meta Platforms, Inc. PAC | $3,000 (2 checks) | Owns Facebook/Instagram/WhatsApp and is one of the largest builders of AI training data centers in the world (Llama models) |
| Amazon.com Services PAC | $3,000 (2 checks: $1,000 + $2,000) | Amazon Web Services — the largest cloud/data-center operator by market share |
| Microsoft Corporation Stakeholders Voluntary PAC | $1,000 | Azure cloud, OpenAI's primary infrastructure and commercial partner |
| Lumen Technologies, Inc. PAC | $1,000 | Fiber-network operator; has signed roughly $8.5 billion in deals with Microsoft, Meta, Google, and AWS since 2024 to build the dedicated fiber routes connecting their AI data centers |
| Samsung Electronics America PAC | $1,000 | Electronics conglomerate whose semiconductor division makes the high-bandwidth memory chips used in AI accelerators |

Every check here is $1,000–$5,000 with no dominant relationship — this still reads like routine "cover the bases" PAC giving, the same read the earlier version of this report gave it.

## The infrastructure: telecom and cable carriers building AI's fiber and wireless backbone — $51,000

This is new. None of these seven companies were in the original keyword list — the earlier version of this report simply never looked for them. Every one of them has a current, documented business tied to AI/data-center connectivity, not just "is a tech-adjacent company":

| PAC / Company | Amount | What it is |
|---|---|---|
| Charter Communications, Inc. PAC | $12,500 (3 checks) | Cable/broadband giant; publicly discussing wholesale fiber connectivity to data centers, and mid-acquisition of Cox Communications (announced May 2025) specifically to expand that business |
| AT&T Inc. Federal PAC / AT&T Inc. Employee Federal PAC | $11,000 (4 checks) | Signed a fiber-interconnectivity master services agreement in July 2026 with Azio AI for a 500 MW Texas AI data campus — a direct, named AI-data-center customer relationship, not just a "tech" company |
| Comcast Corporation & NBCUniversal PAC | $10,000 (2 checks) | Comcast Business bills itself as the largest enterprise fiber-connectivity provider in the US, serving over 90% of the Fortune 500 |
| Cox Enterprises PAC (COXPAC) | $5,000 net (3 rows: $5,000 + $2,500, minus a $2,500 check returned 2025-06-09 — see below) | Cable/broadband company being acquired by Charter (announced May 2025) specifically to combine data-center fiber assets |
| Verizon Communications PAC | $9,500 (5 checks) | Enterprise/business connectivity carrier; part of the same fiber-consolidation wave (Verizon's own pending Frontier acquisition) reshaping who connects hyperscale data centers |
| T-Mobile Political Action Committee | $2,000 (2 checks) | Not a data-center company, but T-Mobile committed roughly $100 million over three years to OpenAI starting in 2024 to build "IntentCX," a custom AI customer-service platform — real, enterprise-scale AI spending, just not data-center infrastructure |
| Ericsson Inc. U.S. Employees PAC | $1,000 | Telecom-equipment maker; its "AI-RAN" product line embeds AI directly into cell-network radios, the same "AI-branded hardware line" pattern as Dell's inclusion above |

**A returned check, not a double-count.** Cox Enterprises PAC's $2,500 check dated 2025-06-09 was returned — the same CSV carries a paired -$2,500 row on the same date, explicitly labeled `RETURNED CHECK FROM 6/9/2025` (`fec/C00753913/schedule_a-2026-07-20T20_08_10.csv:2149`, next to the original at `:2634`). Net effect: $0 from that particular check. It's shown here rather than silently netted out because it's exactly the kind of row a naive FEC.gov search returns as if it were real money — the same pattern shows up, out-of-cycle, in the historical rows the seed list itself included (an AT&T -$2,000 row from 2024 and a Dell -$2,500 row from 2024).

## The power: electric utilities riding the AI power-demand wave — $41,500

This is the report's most substantively documented category, and also the one that most needs a caveat before the table: **August Pfluger sits on the House Energy and Commerce Committee**, which has direct jurisdiction over both telecom and electric-utility policy generally — spectrum, broadband, grid reliability, rate design — independent of any AI angle. Every company below would have a standing reason to keep a seat at the table with an E&C member regardless of the data-center story. What this report can document is that these specific companies' current, real-world business is unusually tied to AI data-center power demand — not that their PAC checks were written *because* of it.

| PAC / Company | Amount | What it is |
|---|---|---|
| American Electric Power Committee for Responsible Government | $10,000 (2 checks) | AEP has signed contracts adding roughly 5,000 MW of data-center load to its grid and won regulatory approval for a first-of-its-kind data-center-specific tariff in Ohio; AEP Texas also serves part of the Permian Basin |
| Vistra Employee PAC | $10,000 (2 checks) | Texas-based (Irving) power generator with signed long-term deals to supply Meta (2.6+ GW nuclear) and AWS; one of the most-cited "AI power demand" stocks on Wall Street |
| Constellation Energy Corporation Employee PAC (CEPAC) | $7,000 (4 checks) | Restarting Three Mile Island Unit 1 — renamed the Crane Clean Energy Center — under a 20-year, 835 MW power-purchase agreement to run exclusively for Microsoft's AI data centers |
| Southern Company Employees PAC | $5,000 (3 checks) | Georgia Power (its subsidiary) won approval for up to $15 billion in spending explicitly to serve new data-center load and signed a 25-year power deal with OpenAI |
| Entergy Corporation PAC (ENPAC) | $5,000 (2 checks) | Building 10 gas-fired power plants (7.5 GW combined) in Louisiana specifically to power Meta's $27 billion Richland Parish AI data center |
| NextEra Energy PAC | $2,500 | Announced a $67 billion acquisition of Dominion Energy in May 2026 explicitly to gain a foothold in Northern Virginia's "Data Center Alley"; also partners with Google Cloud on gigawatt-scale data-center campuses |
| Xcel Energy Employee PAC | $1,000 | Doubled its contracted data-center capacity target to 6 GW by 2027, driven by a 20 GW pipeline of AI-hyperscaler large-load requests |
| PG&E Corporation Employees EnergyPAC | $1,000 | Data-center demand pipeline grew from 5.5 GW to a peak of 10 GW in 2025; announced a $73 billion spending plan through 2030 built around that growth |

**Only two of the eight have any real Texas nexus** (AEP Texas and Vistra, both ERCOT participants) — the other six are giving as part of a national utility-sector pattern tied to data centers built in Ohio, Pennsylvania, Georgia, Louisiana, Virginia, Minnesota, and California, not West Texas. None of it should be read as evidence these utilities are powering anything in TX-11.

**A negative result worth naming inside this category.** The two Texas utilities most specifically tied to *West Texas* and Permian-Basin-adjacent transmission buildout — Oncor Electric Delivery and CenterPoint Energy — returned zero matches anywhere in Pfluger's 2026-cycle data, alongside a repeat of the original report's negative results below.

## Government AI/cloud contracting — $2,500

**Leidos Inc Political Action Committee** gave **$2,500** (`fec/C00753913/schedule_a-2026-07-20T20_08_10.csv:2609`). Leidos partnered with CoreWeave in 2025 to provide AI-cloud services to the U.S. intelligence community and DoD, partnered separately with OpenAI to integrate generative/agentic AI into federal-agency workflows, and holds a $454.9 million Air Force Cloud One modernization contract — a real, current AI-and-cloud federal contractor, not a coincidental name match.

## Reconciling against the seed list

The reader-supplied list that prompted this re-run listed some contributions this report's underlying data can't confirm as separate money, and it's worth explaining why rather than silently adopting or silently dropping them:

- **Peter Lofgren's gift is $5,000, not $10,000.** The seed list showed Lofgren giving $5,000 to the JFC, $3,500 to the campaign, and $1,500 to Raptor PAC on the same day (2026-03-13) — $10,000 total. The campaign and Raptor PAC rows are real CSV rows (`fec/C00719294/schedule_a-2026-07-20T23_36_44.csv:38992`, `fec/C00749481/schedule_a-2026-08-04T22_52_46.csv:30`), but both are `memo_code X` "earmark" rows under `line_number_label` **"Transfers from Authorized Committees"** — FEC's own mechanism for showing how a JFC internally re-allocates a single donor's money to its participating committees ($3,500 + $1,500 = $5,000, exactly Lofgren's one PVC gift). Counting them as new money would triple-count the same $5,000. This project's tooling has excluded memo/earmark rows from donor totals since the companion oil-and-gas report; that exclusion is exactly what's doing its job here.
- **Jared Powell's gift is $500, not $1,000**, for the identical reason — a $500 memo-echo row at the campaign committee (`fec/C00719294/schedule_a-2026-07-20T23_36_44.csv:37942`) mirrors his one $500 PVC gift rather than adding to it.
- **Charter's $5,000 "Raptor PAC" row (2025-09-30) is the same earmark pattern** — a memo row at Raptor PAC (`fec/C00749481/schedule_a-2026-08-04T22_52_46.csv`, transaction `ACE08FE668BEB40189BF`) echoing the PVC check already counted above, not a second $5,000.
- Several other seed-list rows (Ericsson $1,000, AT&T $2,500 "x2", Verizon $1,500/$500, Amazon PAC $1,000/$2,000, Lumen $1,000, Charter Technologies $5,000) matched real, independent CSV rows once checked and are counted in the tables above — the seed list's instinct about *which companies* to look for was good even where its arithmetic needed correcting.
- The seed list's own pre-2026-cycle rows (everything dated 2020–2024) are out of scope for this report, which is deliberately restricted to the 2026 FEC cycle like the rest of this project's reports.

None of this is a knock on the seed list — earmark/memo rows are a genuinely confusing part of FEC data even for careful manual review, which is exactly why this project's tooling has an automated rule for them.

## A tooling bug this report found and fixed

Chasing why the seed list's AEP contribution wasn't appearing in a re-run of the *original* (unexpanded) keyword group surfaced a real bug in `tooling/donor-keyword-scan.rb`, not a data or judgment issue. Raw receipts-shaped `efile-*.csv` files have no `contributor_name` column — only `contributor_last_name`/`first_name`/`middle_name`, and for a PAC/committee-type donor row the committee's full name is filed in `contributor_last_name`, the same field an individual's surname occupies. `scan_efile_gap`'s keyword-matching code was building its search haystack from `row["contributor_name"]` for every committee-type row — a column that doesn't exist in production data — so **every PAC/committee contribution in a committee's not-yet-processed efile window was silently invisible to keyword matching, in every past run of this tool, regardless of group or keyword.** `analyze-candidate.rb` already handles this same efile shape correctly (it always resolves names through `efile_contributor_name`, individual or committee); `donor-keyword-scan.rb` just didn't follow its own sibling tool's pattern.

Fixed in `tooling/donor-keyword-scan.rb` (one-line change, `scan_efile_gap`), and the test fixture that was masking the bug (`tooling/spec/support/fixture_helpers.rb`'s `efile_receipt_row` had a synthetic `"contributor_name"` key no real efile CSV carries) was corrected too, with the existing PAC-row regression test in `donor_keyword_scan_spec.rb` now actually exercising the fixed code path. Full suite (`tooling/spec/donor_keyword_scan_spec.rb`, `tooling/spec/vendor_keyword_scan_spec.rb`) passes: 71 examples, 0 failures.

Concretely, this fix surfaced $9,500 that a bug-free run of even the *original* narrow keyword group would have found: a $2,500 Dell Technologies PAC check and a $2,000 Amazon PAC check dated after Pfluger Victory Committee's processed-export cutoff, both now counted above. It surfaced another $19,500 across the new telecom/utility groups (AT&T $5,000, Comcast $5,000, Charter $2,500, T-Mobile $1,000, AEP $5,000, Constellation $1,000). This is a general-purpose fix, not a report-specific patch — it changes every future run of this tool for every candidate and every keyword group, not just this one.

## What counted, and what didn't (exclusions carried from the original scan)

The original DC-AI-Core scan (unchanged keyword group, now $74,025 gross across 25 rows post-bugfix) still needed the same manual exclusions the earlier version of this report made, none of which changed on review:

- **Substring coincidences on ordinary words ($1,025.00 excluded).** Ryan Albert / Ryan W. Albert's occupation "Business Intelligence" contains "intel" but isn't Intel Corporation ($500 + $500, two separate checks). Paul Neuhoff's employer "GSPMarketing Technologies, Inc." ($25) matched "Technologies" but is a marketing firm.
- **A real company whose business isn't data centers or AI ($12,000 excluded).** "Cisco Equipment," Scott Sibert's Odessa, TX employer, is an oilfield/construction-equipment dealership unrelated to Cisco Systems beyond a shared name.
- **Real technology or aerospace companies that aren't data-center/AI companies ($30,500.00 excluded).** ES3 (Engineering and Software System Solutions) PAC gave $12,000 combined; it's a San Diego aircraft-landing-gear contractor. Matthew Kuta's employer, Voyager Technologies ($7,000), builds the Starlab space station — a technology company, not AI or data centers. Scott Collier's employer, HTX Labs ($2,500), makes VR/XR military training software — adjacent, not AI/data-center as such. SpaceX PAC ($5,000) matched only on "Technologies" in its legal name. The Consumer Technology Association PAC ($1,000, CES's trade group) and the Biotechnology Innovation Organization PAC ($1,000) matched on "Technology"/"techn" fragments describing unrelated industries. The National Multifamily Housing Council/Real Estate Technology and Transformation Center PAC ($2,000) is a real-estate trade group.

**New to this version:** the Telecom-Cable-Network scan also caught **EchoStar Corporation and Dish Network Corporation PAC ($1,000)** — excluded. EchoStar/Dish's current business is satellite TV and 2025's $40+ billion spectrum sale to AT&T and SpaceX (for wireless/direct-to-cell service), not data centers or AI compute; being telecom-adjacent isn't the same test as being data-center/AI-adjacent, the same distinction that excluded Cisco Equipment and SpaceX PAC above.

**A negative result worth repeating.** The original broader scan for well-known AI/data-center names — Nvidia, OpenAI, Palantir, Databricks, Scale AI, C3.ai, Supermicro, Google/Alphabet, Oracle, IBM, Qualcomm, Broadcom, Equinix, Digital Realty, CyrusOne, Vantage Data Centers, Crusoe Energy, and Bitcoin-mining data-center operators (Riot Platforms, Marathon Digital, Core Scientific, Cipher Mining, TeraWulf, Hut 8) — still returns **zero matches**, re-run with the bug fix in place. So does a new check for Oncor Electric Delivery and CenterPoint Energy, the two Texas utility names most specifically tied to West Texas transmission buildout. None of these appear as Pfluger donors anywhere in this data.

## One committee carries almost all of it

Of the $125,500.00 kept total, **$105,000.00 (83.7%)** flowed through the **Pfluger Victory Committee** (the JFC), and **$20,500.00 (16.3%)** went to **August Pfluger for Congress** directly. **Nothing** identifiably data-center/AI-connected went to **Raptor PAC** — the same structural pattern the oil-and-gas report and the earlier version of this report both documented, just at a larger scale: $105,000 against the JFC's $4,564,850.00 in total 2026 itemized receipts is 2.30%.

## What this actually says

1. **The headline finding is still small, but the shape changed.** 2.39% of Pfluger's itemized 2026-cycle receipts trace to the data center/AI industry once telecom carriers and power utilities are counted alongside cloud/hardware names — roughly five times the earlier, narrower version's $26,000 finding, though still a small fraction next to Permian Basin oil-and-gas money.
2. **The most concrete link to AI isn't a household tech name — it's the power grid.** $41,500 from electric utilities with specific, current, multi-billion-dollar AI-data-center power deals (Constellation/Three Mile Island/Microsoft, Entergy/Meta's Louisiana buildout, Southern/OpenAI's 25-year deal, NextEra's $67B Dominion bet) is the single largest, best-documented category in this report — and the one most explainable by Pfluger's Energy and Commerce Committee seat rather than any AI-specific interest, a tension this report can't resolve from FEC data alone.
3. **Telecom carriers are the fastest-growing category, and the earlier version of this report missed it entirely.** $51,000 from AT&T, Verizon, Charter, Cox, Comcast, T-Mobile, and Ericsson — none of which were in the original keyword list — shows up once the report's definition of "the industry" widens to include the fiber and wireless backbone AI data centers actually run on.
4. **A well-known industry's money still conspicuously isn't here.** No Nvidia, OpenAI, Google/Alphabet, data-center REIT, bitcoin-mining operator, or either of the two Texas utilities (Oncor, CenterPoint) most tied to West Texas transmission — a genuine negative finding, re-confirmed after this version's expanded keyword list and bug fix.
5. **This report's own authorship is now a smaller share of its own total.** Two Anthropic employees gave a combined $5,500 — 4.4% of this version's $125,500 kept total, down from 21% of the earlier, narrower version's $26,000. Same disclosure obligation, smaller proportion.

## The self-referential dollar: Anthropic

Unchanged from the earlier version and still worth saying plainly: this report was researched and drafted by Claude, a model built by Anthropic, and the same FEC data it analyzes shows two Anthropic employees gave a combined $5,500 to Pfluger's joint fundraising committee in the 2026 cycle. That's not evidence of anything improper — these are ordinary, small, individually-disclosed contributions, treated with the same keyword-match-then-manual-review process as every other row — but a report about AI-industry money in a candidate's fundraising, written by an AI company's own product, has an obvious appearance-of-interest problem if it doesn't name that fact outright.

## Caveats

"Data center and AI industry" still has no FEC checkbox, and this version widens the definition further than the last one did — telecom and electric-utility PAC money is one or two steps removed from data centers and AI themselves (a carrier's fiber revenue and a utility's load growth are *inputs* to the AI buildout, not AI products), which is a real interpretive choice, not a neutral fact. Whether a utility building gas plants for someone else's data center 1,500 miles from TX-11 counts as "data center/AI industry money" for the purposes of a report about *this candidate* is a judgment call this report makes explicit rather than hides — a reader could reasonably draw the line narrower, at which point this report's total collapses back toward the earlier version's $26,000 (the cloud/hardware/AI-native/individual-donor total, unaffected by this widening). Pfluger's Energy and Commerce Committee seat is a genuine, simpler alternative explanation for the telecom and utility rows specifically, and this report can't distinguish "gave because of AI" from "gave because of committee jurisdiction" from FEC data alone. As before: legal, fully disclosed campaign contributions are not evidence of anything improper by themselves, and a donor whose employer field is blank or who lists a personal name rather than a company wouldn't surface here even if their money originates in this industry.

---

# Methodology & AI Transparency Appendix

*(This section is explicitly excluded from the report's word-count limit.)*

**Report generated:** 2026-08-15, revising the 2026-07-29 original. By Claude Sonnet 5 (Anthropic), running as the "Claude Code" CLI agent inside a VS Code extension session, on behalf of user Tod Beardsley.

**How this revision started:** human-directed refinement of the original report. The user supplied a block of contribution data compiled from their own outside research — telecom and cable-company PAC checks the original keyword scan hadn't covered, plus one electric-utility PAC — and asked for the keyword-search strategy to be expanded to better identify AI/data-center-industry players, with this report re-run against the result. The supplied data itself wasn't taken as ground truth; it was checked against source CSVs like every other figure in this report (see "Reconciling against the seed list" above for where it needed correcting).

**Data sources:** unchanged from the original — the same three FEC Schedule A exports under `tx-11/august-pfluger/fec/` (`C00719294`, `C00749481`, `C00753913`), all three committees' raw `efile-*.csv` receipts scanned for the post-cutoff gap window, no House Ethics data, scoped strictly to `two_year_transaction_period` = 2026.

**Tooling used:**

- `tooling/analyze-candidate.rb` (pre-existing, unmodified) — run first per this project's standing rule:
  ```
  ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics --cycle 2026 --top 40
  ```
  This run shows combined itemized donor receipts of **$5,257,758.43** ($639,908.43 campaign + $53,000.00 Raptor PAC + $4,564,850.00 JFC) — a small amount of expected drift from the original report's $5,256,758.43, from additional efile data landing since 2026-07-29.
- `tooling/donor-keyword-scan.rb` — **one real bug found and fixed in this session** (see "A tooling bug this report found and fixed" above): `scan_efile_gap` was building its keyword-match haystack from a `contributor_name` column that doesn't exist in real receipts-shaped efile CSVs for PAC/committee-type donor rows, silently excluding all such rows from every past run of this tool. Fixed to use `efile_contributor_name(row)` unconditionally, matching `analyze-candidate.rb`'s already-correct handling of the same efile shape. `tooling/spec/support/fixture_helpers.rb`'s `efile_receipt_row` fixture (which had been carrying the same nonexistent field, masking the bug in tests) was corrected, and the existing PAC-row test in `tooling/spec/donor_keyword_scan_spec.rb` now exercises the fix. Full suite: 71 examples, 0 failures (`BUNDLE_GEMFILE=tooling/Gemfile bundle exec rspec tooling/spec/donor_keyword_scan_spec.rb tooling/spec/vendor_keyword_scan_spec.rb`).

  Post-fix runs, four keyword groups:
  ```
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "DC-AI-Core=data center,datacenter,artificial intelligence,machine learning,semiconductor,microchip,hyperscale,cloud computing,colocation,nvidia,microsoft,google,alphabet,amazon,meta platforms,oracle,openai,anthropic,salesforce,intel,amd,qualcomm,broadcom,texas instruments,applied materials,tsmc,samsung,dell technologies,hewlett,hpe,ibm,cisco,equinix,digital realty,vantage data centers,coreweave,crusoe,vertiv,switch inc,data centers,techn,software,fiber optic,broadband" \
    --group "Telecom-Cable-Network=at&t,att inc,warnermedia,verizon,charter communications,spectrum,cox enterprises,comcast,nbcuniversal,lumen,centurylink,ericsson,nokia,t-mobile,sprint,crown castle,american tower,zayo,windstream,consolidated communications,frontier communications,uscellular,dish network,directv" \
    --group "Electric-Utility-AI-Power=american electric power,aep,oncor,centerpoint energy,vistra,nrg energy,exelon,duke energy,southern company,entergy,xcel energy,dominion energy,constellation energy,talen energy,pg&e,pacific gas,edison international,firstenergy,ppl corporation,evergy,pseg,public service enterprise,berkshire hathaway energy,nextera energy,ercot" \
    --group "Gov-Cloud-Defense-IT=saic,leidos,booz allen,caci international,peraton,general dynamics information technology,accenture federal,deloitte consulting"
  ```
  Results: DC-AI-Core 25 rows/$74,025 gross (13 kept/$30,500, 12 excluded/$43,525); Telecom-Cable-Network 21 rows/$52,000 gross (20 kept/$51,000, 1 excluded/$1,000 — EchoStar/Dish); Electric-Utility-AI-Power 16 rows/$41,500 gross (all 16 kept); Gov-Cloud-Defense-IT 1 row/$2,500 (kept). Combined kept total: **$125,500.00** across 50 rows.

  Two supplementary zero-match re-runs (re-confirming the original report's negative result, now with the bug fix in place):
  ```
  ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
    --group "DC-AI-v2=bitcoin,crypto,blockchain,riot platforms,marathon digital,core scientific,cipher mining,argo blockchain,bitdeer,hut 8,terawulf,vantage data,digital realty,cyrusone,aligned data,compute north,iren limited,greenidge,stronghold digital,giga energy,flare mitigation,gpu,graphics processing,large language,generative ai,openai,palantir,scale ai,databricks,c3.ai,supermicro,super micro,arista networks,juniper networks,corning,celestica,nvidia,tesla energy,oncor electric,centerpoint"
  ```
  0 rows matched.

- **Manual review of all 46 primary-scan matches** (25 + 21, DC-AI-Core and Telecom-Cable-Network; the other two groups needed no exclusions) kept 33 rows ($81,500) and excluded 13 rows ($44,525) — see "What counted, and what didn't" and the per-category tables above for the specific reasoning behind each.
- Follow-up Ruby scripts (not saved as tooling, single-use rollups; written to `/tmp` for readable JSON dumps and per-committee/per-keyword subtotals during this session) computed kept/excluded subtotals, per-committee breakdowns, and cross-checked the reader-supplied seed list's rows against the underlying CSVs row-by-row (transaction_id lookups via `grep`).

**Verification performed:** every dollar figure and file:line citation in the body of this report was checked against the source CSV directly before publication, including the specific rows the bug fix newly surfaced (AEP's efile-gap row, Dell's and Amazon's efile-gap rows, and others) and the memo/earmark rows used to explain the seed-list discrepancies for Lofgren, Powell, and Charter.

**Web research:** conducted to verify the *nature* of each new company's AI/data-center business connection — not to establish or adjust any dollar figure. Searches covered: AEP's Ohio data-center tariff and ~5 GW of contracted load; Constellation/Three Mile Island/Microsoft; Entergy/Meta's Louisiana gas-plant buildout; Vistra's Meta/AWS power-purchase agreements; Southern Company/Georgia Power's data-center capital plan and OpenAI deal; NextEra's Dominion acquisition and Google Cloud partnership; Xcel Energy's data-center capacity targets; PG&E's data-center demand pipeline and $73B spending plan; AT&T's Azio AI fiber deal; Charter/Cox's pending merger and wholesale data-center fiber strategy; Comcast Business's enterprise fiber footprint; T-Mobile's OpenAI/IntentCX partnership; Ericsson's AI-RAN product line; Leidos's CoreWeave and OpenAI federal-AI partnerships; and EchoStar/Dish's 2025 spectrum sale to AT&T/SpaceX (used to *exclude* that donor, not include it).

**Model configuration:** default Claude Code agent settings for this session; no unusual temperature/token-limit configuration was requested or applied.

**Note on this report's built-in appearance-of-interest issue:** unchanged from the original — see "The self-referential dollar: Anthropic" above. No dollar figure, inclusion/exclusion decision, or conclusion in this report was adjusted because of Anthropic's own appearance in the data; the same keyword-match-then-manual-review process was applied to those rows as to every other row.

**Verbatim prompt this revision was generated from:**

> A subject matter expert came up with these findings for the story about August Pfluger's support of datacenter expansion in West Texas. I would like to re-run the 2026-datacenters.md report with this in mind. It doesn't have to be exactly the same as these findings, but I think there's some opportunity in here to expand the keyword searches or otherwise come up with strategies to better identify players in AI and datacenter builds.
>
> [a table of ~75 dated contribution rows, largely telecom/cable and electric-utility PACs plus two named Anthropic employees, spanning 2020–2026]
>
> In the transparency section, let's just summarize as "human-directed refinement" or something like that for the rewrite.

**Limitations and things a human should double-check before citing this report further:**

- Still a single-cycle (2026) receipts-only snapshot — no comparison to prior cycles or other candidates.
- The telecom and electric-utility categories are the newest and least battle-tested parts of this report's methodology; the industry-connection judgment calls in those two tables (is a carrier's enterprise-fiber business "data center industry," is a utility's out-of-state power-purchase agreement relevant to a Texas candidate) are laid out explicitly in the Caveats section above specifically so a reader can disagree with them without having to redo the underlying data work.
- The donor-keyword-scan.rb fix changes this tool's output for every future run, not just this report — anyone re-running an older keyword scan against fresh efile data should expect somewhat higher totals than a pre-fix run would have shown, for the same underlying reason documented above.
- No claim is made that any contribution here exceeds a legal contribution limit or otherwise violates FEC rules.
