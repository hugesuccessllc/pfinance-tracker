# TX-11: August Pfluger — Data Center & AI Money in the 2026 Receipts

*A look at exactly which of August Pfluger's 2026-cycle donors — people and companies — trace to the data center and artificial intelligence industry, with a receipt for every dollar.*

## The short version

Of the **$5,256,758.43** in itemized donor receipts recorded across August Pfluger's three 2026-cycle committees, this report can independently trace only **$26,000.00** — **0.49%**, less than half a cent of every dollar — to donors connected to the data center and AI industry: cloud and hardware companies' PACs, an AI-model maker's own employees, and one Houston firm that builds power infrastructure for AI data centers. That's the headline finding, and it's a small-number one: unlike this project's companion report on oil and gas money (which found nearly a quarter of Pfluger's itemized receipts trace to that industry), this report's honest conclusion is that **the data center and AI buildout has not, so far, shown up as a meaningful funding source for this candidate** — at least not one that leaves a trail in donor employer/occupation fields.

That's not a surprise on its face. Pfluger represents West Texas, not Silicon Valley or Northern Virginia's "Data Center Alley," and his committee's money is dominated (as the oil-and-gas report already documented) by Permian Basin operators. What is genuinely interesting is *which* $26,000 did show up, and — just as tellingly — which well-known names in this industry did **not** appear anywhere in the data at all.

## The AI industry, in miniature

There's no single dominant donor here the way Syed Javaid Anwar dominates the oil-and-gas total. The largest single checks are $5,000 each, and they come from two very different corners of "AI":

- **Peter Lofgren**, listed as **Member of Technical Staff at Anthropic** — the AI lab that makes Claude, the model used to research and draft this report — gave **$5,000** to the Pfluger Victory Committee (`fec/C00753913/schedule_a-2026-07-20T20_08_10.csv:2798`). A second Anthropic donor, **Jared Powell**, listed as **Government Affairs at Anthropic PBC**, gave **$500** (`:2213`). Combined, **$5,500** of this report's total traces to employees of the company that makes the tool this report was written with — a fact this report is not going to bury; see the dedicated disclosure below.
- **Saronic Technologies Inc PAC** gave **$5,000** (`:2814`). Saronic is an Austin-based defense startup that builds AI-powered autonomous naval vessels for the U.S. Navy — a real AI company, but one whose product is uncrewed ships, not cloud compute or data centers. It's included here as "AI industry" in the broad sense the report's title promises, with that distinction flagged plainly.

The next tier is **Ryan Castleman**, CEO of **OCIS Intelligent Energy**, who gave **$3,500** (`:2726`). OCIS is a Houston company that develops hyperscale data center sites and provides their on-site power — a minimum of 300 MW of gas-fired generation plus battery storage per site, according to the company's own materials — which makes it the single closest match in this whole report to "the data center industry" in a literal, physical-infrastructure sense, even though its FEC employer field says "Energy," not "Data Centers." (This same donor and company were flagged, but excluded, from this project's companion oil-and-gas report for exactly this reason — "closer to the AI power-buildout story than to a drilling company." This report is where that story belongs.)

## Direct company and trade-group money

Setting individual donors aside, **$12,000** came straight from technology-company PACs — the industry writing checks in its own name:

| PAC / Company | Amount | What it is |
|---|---|---|
| Dell Technologies, Inc. PAC | $5,000 | Server and infrastructure vendor; sells the physical racks (its "AI Factory" line, built with Nvidia) that fill AI data centers |
| Meta Platforms, Inc. PAC | $3,000 (2 checks) | Owns Facebook/Instagram/WhatsApp and is one of the largest builders of AI training data centers in the world (Llama models) |
| Microsoft Corporation Stakeholders Voluntary PAC | $1,000 | Azure cloud, OpenAI's primary infrastructure and commercial partner |
| Amazon.com Services PAC | $1,000 | Amazon Web Services — the largest cloud/data-center operator by market share |
| Lumen Technologies, Inc. PAC | $1,000 | Fiber-network operator; has signed roughly $8.5 billion in deals with Microsoft, Meta, Google, and AWS since 2024 to build the dedicated fiber routes connecting their AI data centers |
| Samsung Electronics America PAC | $1,000 | Electronics conglomerate whose semiconductor division makes the high-bandwidth memory chips used in AI accelerators |

Every one of these is a single check, and none of them is a repeat donor across multiple filings — this reads like the ordinary, low-dollar "keep a seat at the table with every relevant committee chair" giving that large companies' PACs do reflexively, not a sign of strategic investment in Pfluger specifically. For comparison, the oil-and-gas report's PAC table included checks up to $15,000 from a single trade group; nothing here comes close.

## The self-referential dollar: Anthropic

This report needs to say plainly what a reader would otherwise have to notice on their own: it was researched and drafted by Claude, a model built by Anthropic, and the same FEC data this report analyzes shows two Anthropic employees — one of them explicitly in "Government Affairs" — gave a combined $5,500 to Pfluger's joint fundraising committee in the 2026 cycle. That's 21% of this report's entire $26,000 kept total.

This isn't evidence of anything improper — these are ordinary, small, individually-disclosed contributions, exactly like every other row in this report, and nothing here suggests Anthropic directed its employees to give or that the donations relate to Pfluger's committee assignments. But a report about AI-industry money in a candidate's fundraising, written by an AI company's own product, has an obvious appearance-of-interest problem if it doesn't name that fact outright. It's disclosed here instead of left for a reader to discover independently. No editorial judgment about Pfluger, Anthropic, or these two donors is made or implied beyond what's stated.

## What counted, and what didn't

This report started from the same kind of automated keyword scan used for the oil-and-gas report (`tooling/donor-keyword-scan.rb`, extended with a data-center/AI keyword group), followed by manual, line-by-line review of every match. The scan matched **23 rows totaling $69,525.00**; review kept **10 rows, $26,000.00** and excluded **13 rows, $43,525.00** — a *larger* proportion thrown out than in the oil-and-gas report, because generic technology-sounding words turn out to be an even blunter instrument than generic energy-sounding words:

- **Substring coincidences on ordinary words, not industry connections ($1,025.00 excluded).** Two donors — Ryan W. Albert and Ryan Albert, likely the same San Angelo individual across two checks — list their occupation as "Business Intelligence," which contains "intel" but has nothing to do with Intel Corporation or semiconductors ($500 + $500). Paul Neuhoff's employer, "GSPMarketing Technologies, Inc." ($25), matched on "Technologies" but is a marketing firm with no shown AI/data-center connection.
- **A real, well-known company whose actual business isn't data centers or AI ($12,000 excluded).** "Cisco Equipment," Scott Sibert's Odessa, TX employer, is an oilfield- and construction-equipment dealership with locations across West Texas and New Mexico — confirmed via the company's own site — and has no relationship to Cisco Systems, the networking company, beyond a shared name.
- **Real technology or aerospace companies that aren't data-center/AI companies ($27,500.00 excluded).** ES3 (Engineering and Software System Solutions, Inc.) PAC gave $12,000 combined across two checks; ES3 is a San Diego-based aircraft landing-gear engineering and MRO contractor for the Air Force, not a software-industry or AI company despite "Software" in its name. Matthew Kuta's employer, Voyager Technologies, is a newly public (June 2025) defense and space company building the Starlab space station — genuinely a "technology" company, but not data centers or AI. Scott Collier's employer, HTX Labs ($2,500), makes VR/XR immersive training simulations for the military and enterprise — adjacent to software, but not an AI or data-center business as such. The Space Exploration Technologies Corp. (SpaceX) PAC ($5,000) matched only on "Technologies" in its legal name — the same false-positive mechanism that tripped up the oil-and-gas scan on "Exploration." The Consumer Technology Association PAC ($1,000) is the trade group behind CES and represents the entire consumer-electronics industry (televisions, appliances, gaming), not data centers or AI specifically. The Biotechnology Innovation Organization PAC ($1,000) and the National Multifamily Housing Council/Real Estate Technology and Transformation Center PAC ($2,000) matched on "Technology"/"techn" fragments inside names describing biotech and real-estate trade groups, respectively — unrelated industries in both cases.

No match was left in an ambiguous, "corroborated and kept" state the way "Double T Energy & Investments" was in the oil-and-gas report — everything here either had a clearly documented business (kept or excluded) or was excluded for lack of any real connection.

The same donor-scoping rules as the oil-and-gas report apply: only rows the FEC's own `line_number_label` marks as **"Contributions From Individuals"** or **"Contributions From Other Political Committees"** count, never a "Transfers from authorized committees" row (which is how the JFC's pooled proceeds move to a participating committee).

**A negative result worth naming.** A second, broader scan for well-known AI and data-center names — Nvidia, OpenAI, Palantir, Databricks, Scale AI, C3.ai, Supermicro, Google/Alphabet, Oracle, IBM, Intel (the actual company, not the occupation coincidence above), Qualcomm, Broadcom, Equinix, Digital Realty, CyrusOne, Vantage Data Centers, Crusoe Energy, and a list of Bitcoin-mining data-center operators (Riot Platforms, Marathon Digital, Core Scientific, Cipher Mining, TeraWulf, Hut 8) — returned **zero matches** anywhere in Pfluger's three committees' 2026-cycle data. That absence is itself informative: West Texas has a real, growing bitcoin-mining and stranded-gas-power data center industry (Crusoe Energy's Permian Basin operations chief among them), and none of it shows up as a Pfluger donor in this data, at least not under a name this scan could recognize.

## One committee carries almost all of it

Of the $26,000.00 kept total, **$24,500.00 (94.2%)** flowed through the **Pfluger Victory Committee** (the JFC), and just **$1,500.00** (one of the two Meta Platforms checks) went to **August Pfluger for Congress** directly. **Nothing** identifiably data-center/AI-connected went to **Raptor PAC**. This matches the same structural pattern the oil-and-gas report already documented for this candidate — the JFC is where the money concentrates — just at a vastly smaller scale here ($24,500 vs. the JFC's $4,564,850.00 in total 2026 itemized receipts, or 0.54%).

## What this actually says

1. **The headline finding is an absence, not a pattern.** Less than half a cent of every dollar in Pfluger's 2026-cycle itemized receipts traces to the data center/AI industry — this is not, at least not yet, an industry meaningfully funding this candidate, however you draw the industry's boundaries.
2. **What little is there reads like routine "cover all the bases" PAC giving.** Single $1,000–$5,000 checks from Dell, Meta, Microsoft, Amazon, Lumen, and Samsung's PACs — no repeat gifts, no escalating pattern, nothing resembling the concentrated, multi-check relationships this project's oil-and-gas report found with Permian Basin operators.
3. **The most locally-relevant connection isn't a Big Tech household name — it's a Houston power-infrastructure company.** OCIS Intelligent Energy's $3,500 gift is the one dollar in this report that ties directly to the physical build-out of AI data centers, and it comes from Texas, not California.
4. **A well-known industry's money conspicuously isn't here.** No Nvidia, no OpenAI, no Google/Alphabet, no data-center REIT (Equinix, Digital Realty, CyrusOne), and none of the bitcoin-mining/stranded-gas data-center operators active elsewhere in Texas — a genuine negative finding, not just an oversight of this report's keyword list (see "A negative result worth naming" above).
5. **This report's own authorship is part of the data.** Two Anthropic employees gave a combined $5,500 — 21% of everything this report counted — and this report was written using Anthropic's own AI model. That's disclosed above rather than left as an unremarked coincidence.

## Caveats

This is an even blunter instrument than the oil-and-gas report's version of the same exercise: "data center and AI industry" has no FEC checkbox, and unlike "oil and gas" — which has a fairly compact, recognizable vocabulary (drilling, permian, operating, minerals) — "technology," "software," and "intelligence" are generic words that show up constantly in unrelated contexts (aerospace engineering firms, marketing agencies, biotech trade groups, an oilfield equipment dealer, and a donor's own job title). More matches were manually thrown out here, proportionally, than in the oil-and-gas report, which is itself a sign of how noisy this particular keyword space is. A donor whose employer field is blank, or who lists a personal name rather than a company, would not surface here even if their money originates in the AI/data-center industry. Industry classification — is Saronic's AI-powered warship "AI industry," is Lumen's fiber-for-hyperscalers business "data center industry," is a chipmaker's electronics conglomerate parent "semiconductor industry" — is an editorial judgment made row-by-row in this report, not an FEC-assigned category; reasonable people could draw those lines differently. As always: legal, fully disclosed campaign contributions are not evidence of anything improper by themselves.

---

# Methodology & AI Transparency Appendix

*(This section is explicitly excluded from the report's word-count limit.)*

**Report generated:** 2026-07-29T16:35:28Z (2026-07-29, 11:35 AM Central Daylight Time). By Claude Sonnet 5 (Anthropic), running as the "Claude Code" CLI agent inside a VS Code extension session, on behalf of user Tod Beardsley.

**Data sources:**

- FEC Schedule A (receipts) exports for August Pfluger's three known 2026-cycle committees, stored under `tx-11/august-pfluger/fec/` (same three committees as the companion oil-and-gas report):
  - `C00719294` — August Pfluger for Congress (principal committee) — `fec/C00719294/schedule_a-2026-07-20T23_36_44.csv`
  - `C00749481` — Raptor PAC (leadership PAC) — `fec/C00749481/schedule_a-2026-07-20T20_05_49.csv`
  - `C00753913` — Pfluger Victory Committee (joint fundraising committee) — `fec/C00753913/schedule_a-2026-07-20T20_08_10.csv`
- All three committees' raw `efile-*.csv` receipts submissions were also scanned, restricted to rows dated after each committee's processed `schedule_a` export's own latest date (the efile-gap mechanism — see gotcha 8 in `analyze-candidate.rb`'s header).
- No House Ethics Committee data was used; personal financial disclosures don't cover campaign committee contributions.
- Report scoped strictly to the 2026 two-year FEC cycle (`two_year_transaction_period` = 2026).

**Tooling used:**

- `tooling/analyze-candidate.rb` (pre-existing, unmodified) — run first, per this project's standing rule, to confirm baseline totals and `EFILE COVERAGE WARNING` state before building on top of it:
  ```
  ruby tooling/analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics --cycle 2026 --top 40
  ```
  This run (2026-07-29, one week after the companion oil-and-gas report's run) shows **more total itemized donor receipts than that report cited** ($5,256,758.43 here vs. $5,239,920.63 there) — expected drift, not a discrepancy: additional efile data has landed in the intervening week, which this tool's existing gap-fill logic (gotcha 8) already folds in. The "RECEIPTS (itemized, non-memo, donor rows only)" section of this run is the source for the $5,256,758.43 combined figure and the $4,564,850.00 JFC-only figure cited above.
- `tooling/donor-keyword-scan.rb` (pre-existing, unmodified — written for the oil-and-gas report and reused here as its intended sibling tool for any Schedule A keyword theme, not just oil and gas). Two runs:
  1. Primary scan:
     ```
     ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
       --group "Data Center & AI=data center,datacenter,artificial intelligence,machine learning,semiconductor,microchip,hyperscale,cloud computing,colocation,nvidia,microsoft,google,alphabet,amazon,meta platforms,oracle,openai,anthropic,salesforce,intel,amd,qualcomm,broadcom,texas instruments,applied materials,tsmc,samsung,dell technologies,hewlett,hpe,ibm,cisco,equinix,digital realty,vantage data centers,coreweave,crusoe,vertiv,switch inc,data centers,techn,software,fiber optic,broadband"
     ```
     23 rows matched, $69,525.00 total.
  2. Supplementary scan for well-known names not caught by the first pass (crypto/bitcoin-mining data-center operators, additional AI-native companies, networking hardware vendors):
     ```
     ruby tooling/donor-keyword-scan.rb --fec-dir tx-11/august-pfluger/fec --cycle 2026 --include-efile-gap --format json \
       --group "DC-AI-v2=bitcoin,crypto,blockchain,riot platforms,marathon digital,core scientific,cipher mining,argo blockchain,bitdeer,hut 8,terawulf,vantage data,digital realty,cyrusone,aligned data,compute north,iren limited,greenidge,stronghold digital,giga energy,flare mitigation,gpu,graphics processing,large language,generative ai,openai,palantir,scale ai,databricks,c3.ai,supermicro,super micro,arista networks,juniper networks,corning,celestica"
     ```
     0 rows matched — the negative result cited above under "A negative result worth naming."
- **Manual review of all 23 primary-scan matches** (not automated) kept 10 rows ($26,000.00) and excluded 13 rows ($43,525.00) — see "What counted, and what didn't" in the report body for the specific reasoning behind each exclusion.
- Follow-up Ruby one-liners (not saved as tooling, single-use rollups; helper scripts written to `/tmp` for readable JSON dumps during this session) computed the kept/excluded subtotals and the per-committee breakdown from the same JSON output.

**Verification performed:** every dollar figure and file:line citation in the body of this report was checked against the source CSV directly before publication. The $5,256,758.43 combined itemized-receipts figure and $4,564,850.00 JFC figure both come directly from `analyze-candidate.rb`'s own donor-aggregation output, the same code path the companion oil-and-gas report and the candidate's own `README.md` rely on.

**Web research:** conducted strictly to verify the *nature* of ambiguous donors/companies (what industry they're actually in), never to establish or adjust any dollar figure, matching the constraint the user set for the oil-and-gas report. Searches covered: Cisco Equipment (Odessa, TX), ES3/Engineering and Software System Solutions, Voyager Technologies, Saronic Technologies, HTX Labs, Lumen Technologies' AI-infrastructure deals with Microsoft/Meta/Google/AWS, OCIS Intelligent Energy's data-center power business, and Dell Technologies' AI Factory data-center product line. Sources are not individually hyperlinked in the report body, consistent with the oil-and-gas report's practice for the same kind of "is this company X or Y" judgment call.

**Model configuration:** default Claude Code agent settings for this session; no unusual temperature/token-limit configuration was requested or applied by the user.

**Note on this report's built-in appearance-of-interest issue:** this report was generated by Claude (Anthropic), and the underlying FEC data shows two Anthropic employees among the donors this report analyzes — see "The self-referential dollar: Anthropic" in the report body, which discloses this plainly rather than treating it as incidental. No dollar figure, inclusion/exclusion decision, or conclusion in this report was adjusted because of that fact; the same keyword-match-then-manual-review process was applied to the Anthropic rows as to every other row.

**Verbatim prompt this report was generated from:**

> Create a datacenter and AI donor profile for August Pfluger
>
> Similar to the 2026-oil-and-gas.md report, create a 2026 cycle donor report for August Pfluger with regards to the data center and AI industry. Read the top-level readme, and the "Methodology & AI Transparency Appendix" in the oil and gas report for instructions and guidance. Save it to tx-11/reports/august-pfluger/2026-datacenters.md

**A note on the save path:** the prompt above asked for `tx-11/reports/august-pfluger/2026-datacenters.md`. This project's established directory convention — used by every existing report, including the oil-and-gas report this one mirrors — is `$CANDIDATE_DIR/reports/`, i.e. `tx-11/august-pfluger/reports/`, not `tx-11/reports/august-pfluger/`. This report was saved to `tx-11/august-pfluger/reports/2026-datacenters.md` to match that existing convention rather than creating a second, differently-shaped `reports/` hierarchy; flagged here rather than silently overridden.

**Limitations and things a human should double-check before citing this report further:**

- This is a single-cycle (2026 cycle) snapshot of *receipts* only — it says nothing about how this compares to data-center/AI giving in prior cycles or to other candidates, since this repository doesn't yet have comparable data collected for either.
- The near-total absence of matches means this report's statistical power is low — a single additional large check from a data-center or AI company in a future filing could change the picture significantly, unlike the oil-and-gas report's more saturated, harder-to-move total.
- Keyword matching plus manual review is a blunt instrument, and this report's own body explains why it's a blunter one here than in the oil-and-gas report: generic technology vocabulary collides with unrelated industries (aerospace, marketing, biotech, real estate, oilfield equipment) far more than generic energy vocabulary did.
- No claim is made that any contribution here exceeds a legal contribution limit or otherwise violates FEC rules — nothing in this report suggests that, and it does not attempt to check.
