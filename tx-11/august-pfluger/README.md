# TX-11: August Pfluger — Financial Disclosure Summary

Rep. August Pfluger (R-TX11) raises money through three committees: his principal campaign committee, **August Pfluger for Congress** (C00719294); a joint fundraising committee, **Pfluger Victory Committee** (C00753913), which splits large checks among Pfluger's campaign and allied committees; and a mostly dormant leadership PAC, **PFriends of Pfluger** (C00840033). Across itemized FEC filings covering late October 2024 through March 2026, the three committees together raised **$4.24 million** and spent **$5.80 million**, net of refunds and chargebacks (the gap reflects a large campaign cash cushion carried into the cycle — the principal committee alone ended the period with $2.88 million on hand).

## Key Donors

Individuals account for about 75% of itemized money raised ($3.2M); the rest comes from PACs and party committees. One contributor towers over the rest:

| Donor | Amount | Affiliation |
|---|---|---|
| Syed Javaid Anwar | $642,100 | President/CEO, Midland Energy Inc. (Midland, TX) |
| William Crump | $50,000 | Engineer, BC Operating Inc. (Midland, TX) |
| Cody Campbell | $50,000 | Co-CEO, Double Eagle Energy (Fort Worth, TX) |
| John Sellers | $25,000 | Co-CEO, Double Eagle Energy (Fort Worth, TX) |
| Tracy Sellers | $25,000 | Homemaker (Fort Worth, TX) |
| Scott A. Wisniewski | $25,000 | Owner, Western Shamrock Corp. (San Angelo, TX) |
| RCA Energy and Real Estate Properties, LP | $24,000 | Midland, TX |
| Dawn Jewell O'Neil | $22,000 | VP, One Funds (Colorado Springs, CO) |
| Kevin W. O'Neil | $22,000 | CEO, The O'Neil Group (Colorado Springs, CO) |
| Ross Perot Jr. | $22,000 | Dallas, TX |

Nine of these ten donations landed in the Pfluger Victory Committee, the joint fundraising vehicle — its higher combined limits are what let a single donor like Anwar write checks totaling six figures. Most of the biggest names cluster around Permian Basin oil and gas (Midland/Odessa/San Angelo), echoing the district's economic base.

## Major Spending

Of $5.80 million in itemized disbursements, net of vendor credits and refunds:

| Category | Amount | Share |
|---|---|---|
| Transfers (to campaign, NRCC, Raptor PAC, House Conservatives Fund) | $3,168,006 | 55% |
| Administrative/Salary/Overhead | $1,307,170 | 23% |
| Solicitation & Fundraising | $719,159 | 12% |
| Political Contributions (to other committees) | $219,500 | 4% |
| Advertising | $128,800 | 2% |
| Campaign Events | $75,111 | 1% |
| Travel | $64,573 | 1% |
| Everything else (materials, polling, donations, refunds) | $119,580 | 2% |

The "Transfers" line is the joint fundraising committee doing its job: routing pooled money to Pfluger's own campaign ($1.69M), Raptor PAC ($720K), and the NRCC ($863K combined across transfers and direct contributions). The next-biggest vendors are American Express ($652,300) and Citi ($169,791) — both are lump card payments, but that's not the dead end it looks like. Roughly $974,000 across 120 such lump payments (mostly, but not only, the two card processors) is broken down in FEC's own memo sub-items into 1,733 real, vendor-level line items totaling $908,700 — 93% of the lump total. That itemized layer shows $260,400 in travel (American Airlines alone: $71,500) and $332,700 in fundraising-related spend that includes a run of upscale-restaurant tabs: The Capital Grille ($34,000), Del Frisco's Double Eagle Steakhouse ($27,600), Oceanaire ($20,000), and Tosca ($11,200) — all in Washington, DC — plus the Capitol Hill Club ($12,900) and premium car services Savoya and BLS Limo Group (about $24,300 combined). Notable one-off events booked outside the card system: **Stein Eriksen Lodge**, a five-star ski resort in Park City, UT ($43,959, "facility rental and catering"), and a beachfront resort in Panama City Beach, FL ($37,819, same purpose) — both booked through the Victory Committee. The Ritz-Carlton Pentagon City in Arlington, VA shows up repeatedly for lodging throughout the cycle, including a $52,821 refund for an overpayment.

## Takeaways for Political Reporters

1. **One donor, two checks, $642,100.** Syed Javaid Anwar of Midland Energy gave $332,100 in February 2025 and $310,000 in March 2026 to the Pfluger Victory Committee — legal only because joint fundraising committees aggregate the limits of every participating committee. It's by far the single largest funding relationship in the dataset, roughly 15% of all itemized money raised.

2. **Pfluger's donors and his portfolio point the same direction.** The max-donor list is dominated by Permian Basin oil and gas executives (Double Eagle Energy, BC Operating, Midland Energy). A March 13, 2026 STOCK Act disclosure shows Pfluger personally purchasing $15,001–$50,000 stakes in four oil-and-gas-adjacent holdings — Dorchester Minerals, Kimbell Royalty Partners, Enterprise Products Partners, and Viper Energy — plus Berkshire Hathaway and Amerco (U-Haul), in the same window his committees were courting six-figure energy-sector checks.

3. **More than half of "spending" never touches a voter.** The $3.17M "Transfers" category — 55% of all itemized disbursements — is money moving between Pfluger-aligned committees (his campaign, Raptor PAC, House Conservatives Fund, NRCC), not ads or field organizing. Anyone citing a "spending" total without separating this out will overstate direct campaign activity.

4. **Donor retreats at five-star properties.** The Victory Committee paid a ski resort in Park City and a beach resort in the Florida Panhandle nearly $82,000 combined for "facility rental and catering" — a reminder that big-check fundraising often comes with a hospitality bill.

5. **The "black box" credit-card spending isn't actually black.** It's tempting to write off the $652,300 American Express and $169,791 Citi totals as opaque lump sums — that was our first read too. But FEC filings break both down into thousands of memo-linked sub-transactions with real merchant names, and reading those instead of just the card totals turns up a pattern of upscale Washington, DC dining charged to the campaign: The Capital Grille, Del Frisco's, Oceanaire, and Tosca, plus the Capitol Hill Club and two premium car services — around $80,000 combined, layered on top of $71,500 in American Airlines travel. None of it shows up if you stop at the AmEx line item.

## Methodology & AI Transparency

This summary was produced by **Claude Sonnet 5** (model ID `claude-sonnet-5`), running as an agentic coding assistant inside the Claude Code VS Code extension. The session used the harness's default sampling configuration — no explicit temperature or max-output-token override was set by the operator, and those values are controlled by the Claude Code runtime rather than exposed to the model. Analysis was tool-augmented, not a single prompt-to-text completion: the model wrote and ran a reusable Ruby 3.3.8 tool, [`/tooling/analyze-candidate.rb`](../../tooling/analyze-candidate.rb) (dependencies managed via Bundler/`Gemfile`), invoked as:

```
bundle exec ruby analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --house-ethics-dir tx-11/august-pfluger/house-ethics
```

That script parses FEC Schedule A (itemized receipts) and Schedule B (itemized disbursements) CSVs for every committee directory it finds, excluding FEC memo-only entries (`memo_code == "X"`) from dollar totals to avoid double-counting and excluding inter-committee transfers/bank interest from the donor view via each row's `line_number_label` — see the strategy comments at the top of the script for the full rationale. It also extracts text from House Ethics Committee PDF disclosures (via the pure-Ruby `pdf-reader` gem, no external binaries) and surfaces lines containing dollar amounts, which is how the STOCK Act stock-purchase disclosure in Takeaway #2 was located and then verified by hand against the source PDF. The FEC cash-summary figures were read directly from the screenshots as images. Readers should independently verify any figure before republishing; FEC data is self-reported by campaigns and subject to amendment.

**Correction (post-publication review):** a follow-up review, prompted by the operator asking specifically about duplicate/amended filings and whether the credit-card totals were really unexplained, found two issues in the first version of this analysis, both now fixed in the tool: (1) negative correction rows (chargebacks, refunds) were being dropped instead of netted against the donor/vendor they applied to, understating a small number of totals by roughly $15,000 on the receipts side and $38,000 on the disbursements side — none of it large enough to change any figure that appeared in this report, but the underlying bug was real; (2) the "American Express spending is a black box" claim was wrong — FEC's memo-item mechanism (`back_reference_transaction_id`) links each lump card payment to its real, merchant-level sub-transactions, which the original run excluded along with genuinely duplicate memo rows instead of surfacing them separately. That data was there all along; Takeaway #5 above and the restaurant/travel detail in Major Spending reflect the corrected version. Separately, the review checked for the two most likely sources of double-counted totals in financial-disclosure work — amended filings competing with their originals, and raw-vs-processed FEC exports covering the same transactions twice — and found neither pattern in this dataset (see the strategy comments in the script for how to check a future candidate's data for both).

The exact instructions given to the model, verbatim, from this repository's root [`README.md`](../../README.md) under "Summary generation":

> **Tooling requirements:** Any tooling written to perform this analysis must be written in Ruby, using the version pinned in [`.ruby-version`](../../.ruby-version). Save all tooling artifacts (scripts, Rakefiles, etc.) to the `/tooling` directory. Gems should be managed normally with Bundler and a `Gemfile`, so the repo remains portable and reproducible for anyone with `rbenv` and `bundler` installed.
>
> **Analyze financial disclosure documents for TX-11/August-Pfluger and create an executive summary.**
>
> **Output:**
> - Format: Markdown
> - Filename: `tx-11/august-pfluger/README.md`
> - Length: Under 1,000 words
> - Title: `TX-11: August Pfluger — Financial Disclosure Summary`
>
> **Content sections (in this order):**
>
> 1. **Key Donors** — Top 5-10 individual/corporate donors by contribution amount. Include amounts and donor affiliation where relevant.
>
> 2. **Major Spending** — Top disbursements by category (e.g., staff, consulting, media, events). Highlight any unusual or notable expenditures.
>
> 3. **Takeaways for Political Reporters** — 3-5 findings that are newsworthy, unexpected, or revealing about the candidate's priorities, funding sources, or spending patterns. Examples: unusual donor relationships, spending that contradicts public messaging, geographic patterns, or high-interest items like luxury dining or travel.
>
> 4. **Methodology & AI Transparency** — Disclose the LLM model name/version (e.g., Claude 3.5 Sonnet), key configuration settings (temperature, token limits), and the exact prompt used to generate this analysis. This transparency allows readers to understand how findings were produced, assess potential model limitations or biases, and reproduce the analysis if desired.
>
> **Tone:** Analytical, conversational for a general political audience. Avoid jargon; explain significance where needed.
>
> **Source:** All data from FEC and House Ethics Committee disclosures in the `tx-11/august-pfluger/` directory.
