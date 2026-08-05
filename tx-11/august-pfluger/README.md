# TX-11: August Pfluger — Financial Disclosure Summary (2026 Cycle)

August Pfluger's 2026-cycle money doesn't live in one committee — it lives in three, and the shape of the operation matters more than any single number. His principal campaign committee (**August Pfluger for Congress**, C00719294) raised about **$639,908** directly from donors this cycle. The real engine is the **Pfluger Victory Committee** (C00753913), a joint fundraising committee (JFC) that took in **$4,564,850** in large checks and then redistributed the proceeds — roughly **$2.09M** back to the campaign, **$720,323** to his leadership PAC (**Raptor PAC**, C00749481), and about **$874,386** onward to the NRCC, the House Republicans' campaign arm. Raptor PAC, in turn, functions as a political gift shop, writing $1,000–$14,000 checks to some 200 Republican candidates around the country.

Across all three committees, itemized donor receipts total **$5,257,758** for the 2026 cycle — about 74% from individuals ($3.87M) and 26% from PACs and other committees ($1.38M). (Inter-committee transfers among Pfluger's own entities are excluded from that donor total, so the JFC's money isn't counted twice.)

## Key Donors

Every one of the cycle's largest donors gave through the Pfluger Victory Committee, not the campaign itself. A JFC's per-donor limit is the sum of its participants' limits — including the NRCC's high-capacity party accounts — which is how six-figure individual checks are legal here.

| Donor | Amount | Affiliation |
|---|---|---|
| Syed Javaid Anwar (Midland, TX) | **$642,100** | President/CEO, Midland Energy — Permian Basin oil |
| William Crump (Midland, TX) | $50,000 | Engineer, BC Operating (oil & gas) |
| Cody Campbell (Fort Worth, TX) | $50,000 | Co-CEO, Double Eagle Energy |
| Steve Goree (Midland, TX) | $29,000 | Owner, Agri-Empresa |
| John & Tracy Sellers (Fort Worth, TX) | $25,000 each | John is co-CEO, Double Eagle Energy |
| Scott Wisniewski (San Angelo, TX) | $25,000 | Owner, Western Shamrock Corp. (consumer finance) |
| RCA Energy and Real Estate Properties (Midland, TX) | $24,000 | Oil & gas / real estate entity |
| Dana Dickens (San Angelo, TX) | $24,000 | Creekside Rural Investments — real estate |
| Kevin & Dawn O'Neil (Colorado Springs, CO) | $22,000 each | The O'Neil Group / One Funds |
| Ross Perot Jr. (Dallas, TX) | $22,000 | Real estate (Hillwood) |

Just below the cutoff: Liz Bates, Randy Brooks, and Word B. Wilson (self-described "oil & gas exec.") each gave $20,500, all from the San Angelo/Midland corridor.

The single most striking line is Anwar's **$642,100** — one donor supplying roughly 14% of everything the JFC raised this cycle, and about 12% of all donor money across the three committees combined. The rest of the list is heavily Permian Basin energy money (Midland Energy, BC Operating, Double Eagle Energy, plus Agri-Empresa and Creekside Rural Investments), which tracks the district: TX-11 has been the heart of the Permian.

Because all three of Pfluger's committees are collected here — principal, JFC, and leadership PAC — this donor list is drawn from his full committee network, not just the campaign. One caveat: the campaign's own Schedule A also itemizes roughly **$2.07M** ($1,362,058 attributed to named individuals, $707,750 to named PACs) of earmarked pass-through attribution under its "Transfers from authorized committees" line. That is the same money already counted in the JFC's receipts above, not additional funds — noted here so nobody sums the two.

## Major Spending

Combined disbursements across the three committees total about **$8.08M**, but a large share of that is the JFC, campaign, and PAC moving money among Pfluger's own entities and to the party rather than spending it. Setting transfers aside, the real outflows:

- **Administrative, salary and overhead — $1.37M** (566 items). Top staff/vendors: fundraiser Caroline Brennan ($148,627), Grace Dunham ($124,685), CFS Compliance ($142,663), Gusto payroll ($110,222), Norfleet Strategies ($73,067).
- **Political contributions — $1.06M** (456 items). This is Raptor PAC's chit-building at work: checks to roughly 200 Republican candidate committees, topped by Ashley Hinson for Congress ($14,000) and about a dozen at $10,000 (including 2026 recruits and open-seat candidates like Matt Van Epps, Clay Fuller, and Gabe Evans).
- **Fundraising costs — $780K** (135 items), including Hooks Solutions ($102,997) and NGHMH LLC ($44,101).
- **Advertising — just $133K** (13 items), mostly via Targeted Victory ($414.5K total across categories, largely digital fundraising) and Targeted Creative Communications ($46,318). Voter-facing persuasion spending is strikingly thin next to everything else moving through these books.
- **A $1.26M "Uncategorized" line (129 items)** — this isn't a mystery bucket so much as a gap in the underlying data: it's every disbursement that came from raw efile submissions rather than the FEC's processed disclosure export, and raw efile rows simply don't carry a category code the way processed rows do. Breaking it down by hand against the underlying transaction records: about **$673,567** of it is itself more inter-committee transfer money — the JFC sending $400,214 to the campaign, $202,467 to Raptor PAC, $59,852 to the House Conservatives Fund, and $11,035 to the NRCC, all dated 2026-06-26 — that belongs conceptually with the transfer totals above, not with operating spending. The remaining **$584,777** is genuine additional operating spend: six card-processor lump payments to American Express and Citicard ($282,414 combined, not yet broken out to the merchant level — see below), Targeted Victory fundraising consulting ($67,256), legal fees to Berke Farah ($27,600), a $27,151 facility rental at Natural Retreats, and ongoing retainers to NGHMH LLC and Norfleet Strategies.

The biggest apparent vendor, **American Express at $914,558** (plus Citicard at $195,608), is mostly not a black box. The tool's card-breakdown logic matches memo-coded sub-items back to their lump "SEE MEMO ITEMS" parent transaction, and for the $992,708 in such lump payments captured in the processed disclosure data, 94% is itemized down to the merchant: **American Airlines $71,541**; a Washington fine-dining circuit of **The Capital Grille ($34,006), Del Frisco's Double Eagle Steakhouse ($27,582), and Oceanaire ($19,977)** — over $81K in upscale D.C. restaurants; Hilton DC ($19,571); the Capitol Hill Club ($12,850); and about **$36,900 in car services** (Uber, Savoya, BLS Limo). That merchant-level matching only works within the processed schedule_b file, though — it can't reach across into raw efile data. So the roughly $282,414 in American Express/Citicard lump charges that arrived via efile (part of the $584,777 figure above) sit in the topline totals with no vendor-level detail behind them yet.

## Efile coverage

`analyze-candidate.rb` folds in raw efile submissions whenever a committee's processed schedule_a/schedule_b export doesn't yet reflect everything that's been filed, so the totals above are current as of the newest data actually on disk. That gap-filling is active for two of the three committees this cycle:

- **August Pfluger for Congress [C00719294]**: processed data ends 2026-03-31; raw efile data extends coverage to 2026-06-30, adding $504,291 across 1,659 receipt rows and $429,102 across 91 disbursement rows.
- **Pfluger Victory Fund [C00753913]**: processed data ends 2026-03-31; raw efile data extends coverage to 2026-06-30 (receipts) / 2026-06-26 (disbursements), adding $948,850 across 295 receipt rows and $829,243 across 38 disbursement rows.

**Raptor PAC [C00749481]** didn't trigger this warning, and I confirmed why directly rather than just trusting the warning's absence: its processed schedule_a/schedule_b now extend through 2026-06-26/2026-06-30 on their own, and its raw efile files max out at those same dates — processed and raw data agree, with no gap between them. Raptor PAC's numbers above are genuinely current through late June 2026, not merely "no fresher data available."

## Takeaways

1. **This is a leadership operation, not a re-election fight.** Only ~$133K in advertising all cycle, while ~$1.06M went out as political contributions to other Republicans and $874K to the NRCC. Pfluger is spending like a member building chits across the conference — consistent with his position atop the Republican Study Committee — in a cycle when his newly redrawn district (which now reaches into Austin's northern suburbs) apparently isn't seen as needing persuasion dollars.

2. **One Midland oilman is the financial foundation.** Syed Javaid Anwar's $642,100 through the JFC is more than the principal campaign raised from all donors combined ($639,908). When a single donor's checks approach your entire direct-donor base, that relationship is the story.

3. **The Permian pays, and the portfolio matches.** The donor list is dominated by oil-and-gas executives and Permian-adjacent investors — and Pfluger's own House Ethics filings show his household buying, in March 2026, $15,001–$50,000 stakes each in **Dorchester Minerals, Enterprise Products Partners, Kimbell Royalty Partners, and Viper Energy** (alongside Berkshire Hathaway and Amerco/U-Haul) — up to $300,000 in new positions, half of them oil-and-gas royalty/midstream names, filed by a member who sits on the Energy and Commerce Committee. Earlier filings show sales of SiriusXM, Liberty Media, Warner Bros. Discovery, and Disney (each $1,001–$15,000). Dollar figures are disclosure ranges, not exact amounts, and should be verified against the source PDFs in `house-ethics/`.

4. **High-end relational fundraising is the business model.** $81K+ in D.C. steakhouse and seafood-house spending, $36.9K in black-car and rideshare services, $71.5K on American Airlines — and that's before counting the additional $282K in card spending that hasn't been broken out to the merchant level yet. The money is spent cultivating donors and members, not printing yard signs. It's all legal committee spending, but the lifestyle profile of the card statements is notable for a member from San Angelo.

5. **The JFC structure hides the donor picture from casual observers.** Anyone who pulled only the principal committee's report would see a roughly $640K operation and miss more than 85% of the money. The full picture only emerges because all three committees are analyzed together.

## Suggested Committees for Further Investigation

Everything Pfluger *controls* — principal committee, leadership PAC, and JFC — is already collected and analyzed above. From the transfer-recipient list in the local data, two uncollected committees stand out:

- **NRCC [C00075820]** — received **$863,351** from Pfluger's committees this cycle via structured transfer records (plus another ~$11K via an efile-sourced transfer not captured by that same structured field — see Major Spending above), the largest outside recipient by far. It's the national party's House campaign arm, so full itemization would pull in an enormous, mostly-unrelated dataset (the exact failure mode this project's tooling history warns about). If pursued at all: `fec-api-client.rb --with-affiliated` for totals-only context, not a full `--download`.
- **House Conservatives Fund [C00326439]** — received **$70,803**, far more than any candidate committee, and it's the fund historically aligned with the Republican Study Committee that Pfluger chairs. A deliberate `fec-api-client.rb --download --committee-id C00326439` would show whether Pfluger's money is a large share of its budget and where it goes.

The ~200 individual candidate committees receiving $1,000–$14,000 from Raptor PAC are visible in the transfer-recipient list and don't individually warrant collection; the pattern (breadth of giving) is the finding, and it's already fully local.

## Methodology & AI Transparency

- **Model:** Claude Sonnet 5 (`claude-sonnet-5`), running in Claude Code (VS Code extension). Temperature and token-limit settings are the Claude Code harness defaults; they are not user-configured or exposed per-request in this environment.
- **Committees analyzed (all three itemized, 2026 cycle only):**
  - C00719294 — August Pfluger for Congress (principal)
  - C00749481 — Raptor PAC (leadership PAC)
  - C00753913 — Pfluger Victory Committee (JFC)
- **Command run:**
  ```bash
  ruby tooling/analyze-candidate.rb \
    --fec-dir tx-11/august-pfluger/fec \
    --house-ethics-dir tx-11/august-pfluger/house-ethics \
    --cycle 2026
  ```
- **Data provenance:** None of the three committee directories contain `.download-progress` marker files, and their CSVs carry fec.gov export-UI timestamp names, indicating manual collection via the FEC website's CSV export rather than `fec-api-client.rb --download`. C00719294 and C00753913's `schedule_a`/`schedule_b` exports are timestamped 2026-07-20 (efile companions 2026-07-19); C00749481's (Raptor PAC) were collected most recently, timestamped 2026-08-04. The empty `PRINCIPAL` marker file identifies C00719294.
- **EFILE COVERAGE WARNING:** Active for two of the three committees — see "Efile coverage" above for the narrative. In raw terms: August Pfluger for Congress Schedule A (+1,659 rows, +$504,290.64) and Schedule B (+91 rows, +$429,101.78) past a 2026-03-31 processed-data cutoff, extending to 2026-06-30; Pfluger Victory Fund Schedule A (+295 rows, +$948,850.00) past the same cutoff, extending to 2026-06-30, and Schedule B (+38 rows, +$829,242.59), extending to 2026-06-26. Raptor PAC did not trigger the warning; verified directly against its raw `efile-*.csv` files (not merely inferred from the warning's absence) that its processed and raw data both currently extend through 2026-06-26/2026-06-30 with no gap between them.
- **Data-integrity checks that shaped the findings** (per the gotchas documented in `tooling/analyze-candidate.rb`'s header):
  - Raw efile rows lack two structured fields that only the processed export carries: `category_code_full` and `recipient_committee_id`. This has two effects, both unwound by hand for the prose above rather than left as a silent gap: (1) the entire $1,258,344.37 "Uncategorized" line in SPENDING BY FEC CATEGORY is efile-sourced disbursements with no category at all — of which roughly $673,567 is additional inter-committee/JFC transfer money and roughly $584,777 is genuinely new operating spend that would otherwise have landed in Administrative/Fundraising/Travel categories; (2) the "COMMITTEES SEEN AS TRANSFER RECIPIENTS" table, built from the structured `recipient_committee_id` field, misses that same ~$673.6K — so it shows August Pfluger for Congress receiving $1,692,192.47 from its own network, while the TOP PAYEES table (which sums every disbursement row for a payee regardless of category) shows the fuller $2,092,406.45, which is the figure used in this report's narrative.
  - The CARD/BULK PAYMENT BREAKDOWN only reads the processed `schedule_b` file, not efile — its memo-matching logic (matching `memo_code=X` child rows to a parent via `back_reference_transaction_id`) depends on a relationship that only exists within a single processed export. The $992,708.13 lump-payment total and its 94% merchant-level itemization reflect only processed-export data; roughly $282,414 in efile-sourced American Express/Citicard lump charges are counted in the topline "Uncategorized" total but have no vendor-level detail behind them.
  - The TOP PAYEES table's `category` label reflects whichever category was recorded on the *first* row seen for that payee, not the payee's dominant category — visible in this run because NRCC (mostly a structured "Transfers" recipient) is tagged "Political Contributions," and August Pfluger for Congress (mostly "Transfers") is tagged "Administrative/Salary/Overhead Expenses." The narrative above relies on the properly-aggregated SPENDING BY FEC CATEGORY table for category-level claims, not this per-payee tag.
  - The tool's cycle-integrity check flagged 520 rows (across all cycles present in the files, not scoped to 2026) where `fec_election_year` disagrees with `two_year_transaction_period`. Spot-checked examples are small refunds/corrections tagged to unrelated prior election years (2020 vs. 2022); they legitimately belong to whichever two-year period `two_year_transaction_period` assigns them to, and total impact on any 2026-cycle figure cited above is immaterial.
  - Donor totals exclude inter-committee transfers and the campaign's ~$2.07M of memo-itemized JFC pass-through attribution ($1,362,058 individual / $707,750 committee), so JFC money is counted exactly once (at the JFC).
  - House Ethics PDF figures are best-effort text extraction of AcroForm layouts; all cited trades are disclosure ranges and should be verified against the PDFs. One file (30026980.pdf) contains no transaction lines — it appears to be administrative (extension/late-fee boilerplate).
- **Exact prompt used** (v7 template with `$CANDIDATE`/`$DISTRICT`/`$CYCLE` filled in — see the top-level [README.md](../../README.md) for the full template text and its version history):

<details>
<summary>Full verbatim prompt</summary>

````text
CANDIDATE: `August Pfluger`
DISTRICT: `TX-11`
CYCLE: `2026`
````

</details>
