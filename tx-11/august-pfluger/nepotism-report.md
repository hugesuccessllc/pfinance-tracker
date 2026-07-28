# TX-11: August Pfluger — Family Financial Interests & Campaign Giving (2020–2026 Cycles)

*A look at who in August Pfluger's family gives to his campaign network, how much, what their day jobs and family businesses are, and what — if anything — flows back the other way.*

## 0. Data coverage check

Before analyzing anything, this report confirms all three of Pfluger's already-collected committees have itemized data spanning every cycle from 2020 through the current (2026) cycle. Running `analyze-candidate.rb --by-cycle` against `tx-11/august-pfluger/fec/` confirms four distinct cycle blocks — **2020, 2022, 2024, and 2026** — and every one of the three committees reports non-zero itemized receipts and disbursements in every cycle:

| Committee | 2020 | 2022 | 2024 | 2026 |
|---|---|---|---|---|
| August Pfluger for Congress (C00719294) | $2,248,944.53 | $1,533,149.67 | $1,537,577.62 | $638,070.63 |
| Raptor PAC (C00749481) | $236,600.00 | $107,922.50 | $170,100.00 | $52,000.00 |
| Pfluger Victory Fund/Committee (C00753913) | $46,600.00 | $2,628,075.00 | $3,283,565.79 | $4,549,850.00 |

(Figures are itemized donor receipts per cycle, from the tool's `--by-cycle` output.) No committee is missing a cycle, so this report proceeds using the full 2020–2026 span already sitting in `fec/`. Per the repo's data-integrity note, the 2026 cycle also carries an **EFILE COVERAGE WARNING** — the processed Schedule A/B exports for C00719294 and C00753913 stop at 2026-03-31, and this analysis, like the existing README, pulls in the raw efile data through the most recent filings (2026-06-30 for receipts) to avoid understating the current cycle. House Ethics data consists of eight Periodic Transaction Reports (PTRs) covering 2025–2026 stock trades, plus one filing-extension request; no annual Financial Disclosure (FD) form — the document type that would normally list a spouse's employer — is present in `house-ethics/`, so spousal/family employment below is reconstructed from FEC donor-occupation fields and public web sources, not from an FD.

## 1. The short version

August Pfluger's family — parents, a brother, a sister, grandparents' generation, aunts, uncles, and in-laws — has given his three committees combined **at least $266,114.69** in identified, non-memo itemized contributions since the 2020 cycle, spread across roughly 30 individuals who share his surname or are married into it. That's a real number, but it's also a shrinking share of an operation that has grown much larger around it: family giving held roughly steady at $58,000–$81,000 per cycle while the campaign's total itemized haul (driven mostly by the Pfluger Victory Fund JFC) grew from $2.5 million (2020) to $5.2 million (2026) — so family money fell from about **3.2% of the take in 2020 to about 1.1% in 2026**.

More interesting than the dollar figure is the picture it paints alongside public records: this is a multi-generational West Texas ranching family (the Pflugers helped found Pflugerville in the 1850s and have ranched in Kimble/Concho/Sutton counties since the 1870s) that has, in the current generation, also moved into Permian Basin oil-and-gas management — most visibly through August's brother Karl, president of Midland-based Oryx Midstream Services. That overlap between family business and Pfluger's donor base (heavily Permian energy money, as the main README already documents) and his committee assignments (he sits on House Energy and Commerce) is the more substantive story than the raw dollar totals from relatives.

No evidence was found, in either the FEC disbursement data or the House Ethics filings collected here, of money flowing the other direction — no campaign or PAC payment to any family member, family business, or family-linked vendor. Whatever "nepotism" exists here is about **shared financial interests and a family-and-friends donor base**, not payroll.

## 2. Reconstructing the family tree from public records

FEC contributor records only give a name, city, employer, and occupation — never a stated relationship. To go from "someone named Pfluger in San Angelo" to "August Pfluger's actual relative," this report cross-referenced FEC donor rows against public sources: a 2025 obituary for August's grandfather, Robert Lee Pfluger (San Angelo Live / Harper Funeral Home, 2025-10-11), Wikipedia/Grokipedia biographical entries, a Reuters-sourced Truth Social funding story, a ranch-history page, and public-record aggregator listings. Confidence varies by name, so this report tiers the findings rather than presenting them all as equally certain.

**Confirmed (multiple independent sources agree):**
- **Karl Pfluger** — August's brother, per Wikipedia and Reuters/Yahoo Finance reporting on Truth Social's funders. FEC records show Karl and his wife Cecilie giving together (same date, same $2,800 amount, 2019-09-19); the obituary independently lists "Karl R. Pfluger (spouse: Cecilie)" as a grandson of Robert Lee Pfluger, matching. Karl's FEC-listed employer is **Oryx Midstream Services**, Midland, where he is president — a crude-oil-gathering and pipeline company owned by private equity firm Stonepeak Infrastructure Partners.
- **Genevieve Pfluger Mejia** — August's sister, per the same obituary ("Genevieve Pfluger Mejia," listed as a grandchild alongside "August L. Pfluger II" and "Karl R. Pfluger"). FEC records show her and husband Brian Mejia giving together (same date, same amount, same San Angelo address) — both listed as physicians at **Shannon Medical Center**, San Angelo.
- **Robert E. Pfluger and Katrina Pfluger** — August's uncle and aunt. The obituary lists Robert Lee Pfluger's son "Robert E. Pfluger (spouse: Katrina)"; FEC records show a "Robert Pfluger" (self-employed farmer/rancher) and "Katrina Pfluger" (self-employed, real estate) giving on the same date and same San Angelo zip code.
- **Audrey (Pfluger) Williams** — August's aunt. The obituary lists her as a daughter of Robert Lee Pfluger; FEC records show an Audrey Williams (teacher, Dallas, TX) giving $5,600 in the 2020 cycle.
- **Robert Lee Pfluger** — August's paternal grandfather, a lifelong Sutton County rancher (Angora goats, Hereford cattle) who died October 11, 2025 at age 95. He does not appear by that full name in the FEC data collected here; if he gave, it was likely under a shortened or different name (see below).

**Very likely, based on circumstantial but strong evidence:**
- **Walter and Sheryl Pfluger** — the obituary's ordering places "August L. Pfluger II," "Genevieve Pfluger Mejia," and "Karl R. Pfluger" as the first three grandchildren listed, immediately following Robert Lee Pfluger's first-listed child, "Walter W. Pfluger (spouse: Sheryl)" — the standard convention in obituaries of grouping grandchildren under their parent. FEC records show a Walter Pfluger and Sheryl Pfluger, both listed at **Gentry Creek Ranch**, San Angelo, giving together in 2019 and 2024. A ranch-history page for Gentry Creek Ranch (gentrycreekranch.com) says the property was bought in the 1930s by "Walter L. Pfluger" — most likely August's great-grandfather — and states a "Walter" still operates it today, consistent with this being the current-generation Walter (August's father) running the family ranch. **This report cannot independently confirm parentage beyond this circumstantial match** — no source states outright "August Pfluger's father is Walter Pfluger" — but the convergence of the obituary's grouping, the shared ranch employer, and the geography makes it the most probable reading of the public record.
- **Kay and Larry Cole** — likely August's parents-in-law. Public bio sources describe August's wife as "Camille Cole Pfluger... born and raised in Hillsboro, Texas, where her family still resides." FEC records show a Kay Cole and Larry Cole, both retired, of Hillsboro, TX, giving to the Pfluger Victory Fund and principal committee. A public-records aggregator lists "Kay B Cole" and "Larry Lee Cole" as possible relatives of Camille Cole Pfluger, matching on name and approximate age. Not independently confirmed as her parents by a primary source, but consistent on every available data point (name, town, generation).

**Same surname, San Angelo/West Texas ranching community, relationship not confirmed:** Bill Pfluger and Karen Pfluger (same 2133 Office Park Dr., San Angelo address — almost certainly a married couple; public business records separately show a "Bill Pfluger" as president of Pfluger Mineral Management, LLC at that same address), Lee Pfluger (self-employed investor), Reid Pfluger (WRP Ranch — the initials plausibly stand for a "William Reid Pfluger," which would tie this person to the Bill/William Pfluger household, though this report can't confirm it), William C. Pfluger (a *different* San Angelo address from Bill/Karen, so apparently a distinct individual), Candyce Pfluger (CPA), Craig Pfluger (rancher, Eden, TX — Eden is where Robert Lee Pfluger's own parents, Walter L. and Jewel Blanche Pfluger, were from), Amy Pfluger, Susan Pfluger, and Raymond Pfluger (the 1930s Gentry Creek Ranch co-purchaser was also a "Raymond Pfluger," so this is likely a descendant/namesake rather than the same person). Also **Alicia Cole and Sterling Cole**, San Angelo ranchers, who share the Cole surname and giving pattern of Kay/Larry Cole but whose relationship to Camille (sibling? cousin? in-law?) isn't established here.

This report did not find August's wife, Camille Pfluger, or his three minor daughters as FEC donors under any name variant — consistent with contribution law (minors generally can't make political contributions from their own funds) and with Camille simply not appearing as an itemized donor in this data.

## 3. Family giving, by the numbers

Combining every contribution above — the Pfluger surname plus the confirmed/likely in-laws (Mejia, Audrey Williams, and the Cole names) — and deduplicating by FEC transaction ID across the processed Schedule A exports and the raw efile gap-fill data:

| Cycle | Family total | Committee-wide itemized receipts (all 3 cmtes) | Family share |
|---|---|---|---|
| 2020 | $81,300.00 | $2,532,144.53 | 3.2% |
| 2022 | $67,694.39 | $4,269,147.17 | 1.6% |
| 2024 | $58,700.00 | $4,991,243.41 | 1.2% |
| 2026 | $58,420.30 | $5,239,920.63 | 1.1% |
| **Total** | **$266,114.69** | — | — |

By individual (top contributors, all cycles combined):

| Donor | Total | Employer / role (self-reported to FEC) | Relationship (confidence) |
|---|---|---|---|
| Karen Pfluger | $40,400.00 | Retired | Same address as Bill Pfluger — unconfirmed |
| Bill Pfluger | $37,700.00 | Retired (president, Pfluger Mineral Management LLC per public records) | Unconfirmed |
| Tanya Pfluger | $27,400.00 | San Angelo Ballet / self-employed investor | Unconfirmed |
| Karl Pfluger | $27,200.00 | President, Oryx Midstream Services | **Brother (confirmed)** |
| Lee Pfluger | $26,400.00 | Self-employed investor | Unconfirmed |
| Reid Pfluger | $25,900.00 | Principal, WRP Ranch | Unconfirmed |
| Candyce Pfluger | $12,150.00 | CPA, self-employed | Unconfirmed |
| William Pfluger | $10,000.00 | Self-employed | Unconfirmed |
| Sheryl Pfluger | $6,800.00 | Gentry Creek Ranch | **Likely mother** |
| Amy Pfluger | $5,700.00 | Self-employed investor | Unconfirmed |
| Audrey Williams | $5,600.00 | Teacher, Dallas TX | **Aunt (confirmed)** |
| Walter Pfluger | $5,600.00 | Gentry Creek Ranch | **Likely father** |
| Brian Mejia | $5,600.00 | Physician, Shannon Medical Center | **Brother-in-law (confirmed)** |
| Genevieve Mejia | $5,600.00 | Physician, Shannon Medical Center | **Sister (confirmed)** |
| Cecilie Pfluger | $5,600.00 | Homemaker | **Sister-in-law (confirmed)** |
| August Pfluger (self) | $4,414.69 | Rancher, Pfluger Family Ranches | The candidate's own small-dollar personal gifts |
| Robert Pfluger | $3,850.00 | Self-employed farmer/rancher, retired | **Uncle (confirmed)** |
| Alicia Cole | $3,000.00 | Self-employed rancher/farmer | Cole family, unconfirmed |
| Kay Cole | $2,000.00 | Retired | **Likely mother-in-law** |
| Craig Pfluger | $1,700.00 | Self-employed rancher, Eden TX | Unconfirmed |
| Larry Cole | $1,000.00 | Retired | **Likely father-in-law** |
| Susan Pfluger | $750.00 | Retired | Unconfirmed |
| Sterling Cole | $750.00 | Self-employed rancher | Cole family, unconfirmed |
| Raymond Pfluger | $500.00 | Retired | Unconfirmed |
| Katrina Pfluger | $500.00 | Self-employed, real estate | **Aunt (confirmed)** |

A few patterns worth flagging:
- **Family giving clusters on single dates**, consistent with a targeted family fundraising ask rather than organic, spread-out giving. On 2019-09-30 alone, nine different Pfluger relatives gave to the principal committee on the same day. On 2026-05-04, Bill, Karen, Tanya, and Reid Pfluger each gave exactly **$8,500** to the Pfluger Victory Fund on the same date — a coordinated round of maxed-out JFC checks.
- **Most family gifts sit at or near the legal per-election maximum** for whichever committee received them — the same pattern any well-organized "friends and family" fundraising round follows, and the family is treated, mechanically, the same as any other maxed-out donor bloc.
- **August's own listed occupation on his 2025–2026 personal contributions is "Rancher," employer "Pfluger Family Ranches"** — notable for a sitting member of Congress, and confirmation that the family ranching operation is still how he identifies himself on federal paperwork even in his current job.

## 4. Family business interests

- **Oryx Midstream Services** (Midland, TX) — August's brother Karl Pfluger is president. Oryx is a crude-oil gathering and pipeline operator in the Permian Basin, owned by Stonepeak Infrastructure Partners. Reuters/Yahoo Finance reporting on Trump Media & Technology Group's early funders states Karl personally invested **$5.3 million in December 2021 and $4.5 million more in March 2022** ($9.8 million total) in Trump Media (Truth Social) — separate from, and far larger than, anything in the FEC data here, but relevant context: Pfluger's brother is a significant early financial backer of Donald Trump's media company. A spokesperson for August Pfluger told Reuters that investment was Karl's personally, not the congressman's.
- **Gentry Creek Ranch** (Kimble County, near San Angelo) — a hunting-and-ranch-experience operation (deer hunting, "cowboy experiences," corporate retreats) that, per its own website, traces to an 1930s purchase by Walter L. Pfluger and has been in the family since. FEC records list Walter and Sheryl Pfluger's employer as Gentry Creek Ranch.
- **WRP Ranch** — employer listed by Reid Pfluger ("principal"). This report could not independently verify what WRP stands for or its full ownership structure beyond the FEC filing itself.
- **Pfluger Family Ranches** — the employer August Pfluger lists for his own small personal contributions in 2025–2026, distinct from Gentry Creek Ranch in the FEC data, suggesting the family's ranching interests span more than one named operation across Kimble, Concho, and Sutton counties (the counties Pfluger's own campaign biography cites).
- **Pfluger Mineral Management, LLC** — a mineral-rights management company; public business records list a "Bill Pfluger" at the same San Angelo street address (2133 Office Park Dr.) as the FEC's Bill and Karen Pfluger. Not further investigated beyond confirming the address match.
- **San Angelo Ballet** — Tanya Pfluger's listed employer/role is "Executive Director." This is a nonprofit arts organization, not a business, but is included here since it recurs across multiple cycles of her donor records.

## 5. What this report did *not* find

Searching every disbursement record (`schedule_b-*.csv` and the disbursement-side `efile-*.csv` files) across all three committees for any payment to a Pfluger-surname recipient, or to any of the family business names above (Gentry Creek Ranch, WRP Ranch, Pfluger Family Ranches, Oryx Midstream Services), returned **zero results**. No family member appears as a paid campaign staffer, consultant, or vendor in this data, and no family-linked business was paid by the campaign, the leadership PAC, or the JFC. If Pfluger's congressional office (not his campaign committees) employs a relative, that would appear in House payroll disclosures, which are a separate data source not collected in this repo's `house-ethics/` directory and were not investigated here.

The House Ethics Periodic Transaction Reports on file (covering January 2025–March 2026) show a handful of relevant details about the immediate household's finances, though not employment: several stock trades are held in accounts explicitly owned by "SP" (spouse) — a Roth IRA holding Warner Bros. Discovery and SiriusXM shares — and by "DC" (dependent child) — a custodial Roth IRA ("CP Roth IRA") that received shares of Liberty Media spinoffs (Liberty Formula One, Liberty Live) through a 2025 corporate merger, and separately bought SiriusXM stock in January 2026. The March 2026 filing (already flagged in the main README) shows August's own accounts buying $15,001–$50,000 stakes each in four oil-and-gas royalty/midstream names — Dorchester Minerals, Enterprise Products Partners, Kimbell Royalty Partners, and Viper Energy — the same month he chairs the Republican Study Committee and sits on Energy and Commerce, and the same sector that supplies both his top donors and his brother's employer. None of these trades are illegal or even unusual for a member with this portfolio, but they underline that the family's financial interests and the congressman's own investment activity sit in the same industry as his committee assignments and his donor base.

## 6. Takeaways

1. **This is a real "friends and family" donor bloc, not a scandal-scale one.** $266,114.69 across six years and roughly two dozen people is a meaningful, well-organized contribution stream — but it's dwarfed by single major donors (Syed Javaid Anwar alone gave $957,900 across the four cycles) and by the JFC's institutional fundraising. Family money's *share* of the total operation has shrunk by two-thirds since 2020 even as its *absolute* size stayed roughly flat.
2. **No money flows back to the family.** Every disbursement schedule across all three committees was searched for family names and family businesses; none turned up as paid recipients. Whatever benefit exists here is reputational and relational, not direct payroll.
3. **The family's business footprint is genuinely dual: ranching and oil.** The Pflugers are a multi-generational West Texas ranching family (Gentry Creek Ranch, Pfluger Family Ranches, WRP Ranch) that has, in Karl Pfluger's generation, also become a Permian Basin energy management family (Oryx Midstream) — mirroring, almost exactly, the donor profile (oil-and-gas executives) that funds the campaign and the committee assignments (Energy and Commerce) the congressman holds.
4. **Karl Pfluger's $9.8 million Truth Social investment is the single largest number in this report, and it's not campaign-related at all.** It's outside the scope of FEC campaign-finance data entirely, but it's a substantial family financial interest in Trump-aligned media that's relevant context for anyone assessing the Pfluger family's broader political and financial entanglements. August Pfluger's office has stated it isn't his personal investment.
5. **Coordinated giving dates suggest organized "ask" events, not spontaneous generosity.** Multiple relatives giving the identical amount on the identical date, in more than one cycle, points to the campaign or family itself running periodic rounds of maxed-out family checks — ordinary practice for a well-run campaign, but worth naming plainly rather than treating each gift as independent.

## Methodology & AI Transparency

- **Model:** Claude Sonnet 5 (`claude-sonnet-5`), running in Claude Code (VS Code extension). Temperature/token settings are harness defaults, not user-configured.
- **Scope:** This is a custom analysis outside the standard "Default current cycle summary" or "Deep-dive" prompt templates in the repo's main README — it was commissioned directly, with its own instructions (family financial interests and donations only, full 2020–2026 span, permission to use the web to confirm family businesses and relationships, save to `nepotism-report.md`). It otherwise follows the repo's standing rules: analysis only draws on data already collected in `tx-11/august-pfluger/fec/` and `tx-11/august-pfluger/house-ethics/`, and does not download or itemize anything new.
- **Committees analyzed (all three, all locally available cycles, 2020–2026):**
  - C00719294 — August Pfluger for Congress (principal)
  - C00749481 — Raptor PAC (leadership PAC)
  - C00753913 — Pfluger Victory Fund / Pfluger Victory Committee (JFC)
- **Commands run:**
  ```bash
  ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --by-cycle
  ```
  Family-specific donor extraction and per-cycle aggregation were done with two small one-off Ruby scripts (not saved to `/tooling`, since this was ad hoc surname/employer matching over the already-loaded CSVs rather than reusable candidate-analysis logic) that: (1) filtered every `schedule_a-*.csv` and receipt-side `efile-*.csv` row across all three committees to contributor last name "PFLUGER" plus the confirmed in-law surnames (Mejia, Williams, Cole) restricted to matched first names, (2) deduplicated by `transaction_id` (preferring the processed `schedule_a` row over its raw-efile counterpart where both existed, to avoid double-counting the same gift), and (3) excluded memo-coded rows (`memo_code = X`) to avoid double-counting JFC pass-through attribution the way the main README's methodology already does. Disbursement files (`schedule_b-*.csv` and disbursement-side `efile-*.csv`) were separately searched for the same surnames and for named family businesses to check for money flowing back to the family; this returned no matches.
- **Data provenance:** Same as the existing `README.md` in this directory — no `.download-progress` marker files are present, and all three committees' CSVs carry fec.gov export-UI timestamp filenames, indicating manual collection via the FEC website rather than `fec-api-client.rb`.
- **Web sources used to identify family relationships and businesses** (see inline citations above for which claim each source supports):
  - [Robert Lee Pfluger obituary, San Angelo Live, 2025-10-11](https://sanangelolive.com/community/obituaries/2025-10-11/robert-lee-pfluger) and the [Harper Funeral Home version](https://www.harper-funeralhome.com/obituaries/robert-pfluger) — source for the grandfather's identity, children, and grandchildren list.
  - [August Pfluger — Wikipedia](https://en.wikipedia.org/wiki/August_Pfluger) — source for wife Camille (née Cole), three daughters, ranching background, brother Karl.
  - Reuters-sourced reporting on Trump Media & Technology Group funders, as aggregated by [Yahoo Finance](https://finance.yahoo.com/news/funded-trump-truth-social-answers-100134820.html) and [Gizmodo](https://gizmodo.com/donald-trump-truth-social-1849714452) — source for Karl Pfluger's $9.8M Truth Social investment and his role as Oryx Midstream Services president.
  - [Gentry Creek Ranch history page](https://www.gentrycreekranch.com/history.html) — source for the ranch's 1930s founding by Walter L. Pfluger and current operation.
  - Public-record aggregator listings (InstantCheckmate, Manta, CorporationWiki, Yelp business listings) — used only to cross-check names, approximate ages, and business addresses already present in the FEC data; not used as a standalone source for any claim not otherwise corroborated.
- **Confidence caveats:** Relationship labels above are explicitly tiered (confirmed / very likely / unconfirmed) because FEC data never states a donor's relationship to the candidate. Readers should treat anything marked "unconfirmed" as "shares a surname and a West Texas ranching-community address with the congressman's confirmed relatives," not as a verified family relationship. This report deliberately did not guess at relationships for names it couldn't cross-reference against an independent source (e.g., Lee Pfluger, Reid Pfluger, Candyce Pfluger) rather than assert a specific family role without evidence.
- **Word count note:** This report runs longer than the ~2,000-word target used for the standard current-cycle summary, reflecting its broader six-cycle, cross-referenced scope; the Methodology section itself is excluded from any such count per the repo's existing convention.
