# TX-11: August Pfluger — Financial Disclosure Summary

Rep. August Pfluger (R-TX11) raises money through three committees: his principal campaign committee, **August Pfluger for Congress** (C00719294); a joint fundraising committee, **Pfluger Victory Committee** (C00753913), which splits large checks among Pfluger's campaign and allied committees; and a mostly dormant leadership PAC, **PFriends of Pfluger** (C00840033). Across itemized FEC filings covering late October 2024 through March 2026, the three committees together raised **$4.26 million** and spent **$5.84 million** (the gap reflects a large campaign cash cushion carried into the cycle — the principal committee alone ended the period with $2.88 million on hand).

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

Of $5.84 million in itemized, non-memo disbursements:

| Category | Amount | Share |
|---|---|---|
| Transfers (to campaign, NRCC, Raptor PAC, House Conservatives Fund) | $3,168,006 | 54% |
| Administrative/Salary/Overhead | $1,324,598 | 23% |
| Solicitation & Fundraising | $723,806 | 12% |
| Political Contributions (to other committees) | $223,500 | 4% |
| Advertising | $128,800 | 2% |
| Campaign Events | $75,111 | 1% |
| Travel | $64,573 | 1% |
| Everything else (materials, polling, donations, refunds) | $131,625 | 2% |

The "Transfers" line is the joint fundraising committee doing its job: routing pooled money to Pfluger's own campaign ($1.69M), Raptor PAC ($720K), and the NRCC ($863K combined across transfers and direct contributions). The next-biggest vendors are American Express ($652,300) and Citi ($169,791) — lump credit-card payments rather than itemized purchases. Notable one-off events: **Stein Eriksen Lodge**, a five-star ski resort in Park City, UT ($43,959, "facility rental and catering"), and a beachfront resort in Panama City Beach, FL ($37,819, same purpose) — both booked through the Victory Committee. The Ritz-Carlton Pentagon City in Arlington, VA shows up repeatedly for lodging throughout the cycle, including a $52,821 refund for an overpayment.

## Takeaways for Political Reporters

1. **One donor, two checks, $642,100.** Syed Javaid Anwar of Midland Energy gave $332,100 in February 2025 and $310,000 in March 2026 to the Pfluger Victory Committee — legal only because joint fundraising committees aggregate the limits of every participating committee. It's by far the single largest funding relationship in the dataset, roughly 15% of all itemized money raised.

2. **Pfluger's donors and his portfolio point the same direction.** The max-donor list is dominated by Permian Basin oil and gas executives (Double Eagle Energy, BC Operating, Midland Energy). A March 13, 2026 STOCK Act disclosure shows Pfluger personally purchasing $15,001–$50,000 stakes in four oil-and-gas-adjacent holdings — Dorchester Minerals, Kimbell Royalty Partners, Enterprise Products Partners, and Viper Energy — plus Berkshire Hathaway and Amerco (U-Haul), in the same window his committees were courting six-figure energy-sector checks.

3. **Over half of "spending" never touches a voter.** The $3.17M "Transfers" category — 54% of all itemized disbursements — is money moving between Pfluger-aligned committees (his campaign, Raptor PAC, House Conservatives Fund, NRCC), not ads or field organizing. Anyone citing a "spending" total without separating this out will overstate direct campaign activity.

4. **Donor retreats at five-star properties.** The Victory Committee paid a ski resort in Park City and a beach resort in the Florida Panhandle nearly $82,000 combined for "facility rental and catering" — a reminder that big-check fundraising often comes with a hospitality bill.

5. **Credit-card spending is a black box.** AmEx and Citi are the two largest vendors after party and PAC transfers ($822,091 combined), but FEC rules only require the lump sum plus itemized fees/interest — the underlying purchases (what was actually bought) aren't disclosed anywhere in these filings.

## Methodology & AI Transparency

This summary was produced by **Claude Sonnet 5** (model ID `claude-sonnet-5`), running as an agentic coding assistant inside the Claude Code VS Code extension. The session used the harness's default sampling configuration — no explicit temperature or max-output-token override was set by the operator, and those values are controlled by the Claude Code runtime rather than exposed to the model. Analysis was tool-augmented, not a single prompt-to-text completion: the model wrote and ran a reusable Ruby 3.3.8 tool, [`/tooling/analyze-candidate.rb`](../../tooling/analyze-candidate.rb) (dependencies managed via Bundler/`Gemfile`), invoked as:

```
bundle exec ruby analyze-candidate.rb --fec-dir tx-11/august-pfluger/fec --house-ethics-dir tx-11/august-pfluger/house-ethics
```

That script parses FEC Schedule A (itemized receipts) and Schedule B (itemized disbursements) CSVs for every committee directory it finds, excluding FEC memo-only entries (`memo_code == "X"`) to avoid double-counting and excluding inter-committee transfers/bank interest from the donor view via each row's `line_number_label` — see the strategy comments at the top of the script for the full rationale. It also extracts text from House Ethics Committee PDF disclosures (via the pure-Ruby `pdf-reader` gem, no external binaries) and surfaces lines containing dollar amounts, which is how the STOCK Act stock-purchase disclosure in Takeaway #2 was located and then verified by hand against the source PDF. The FEC cash-summary figures were read directly from the screenshots as images. Readers should independently verify any figure before republishing; FEC data is self-reported by campaigns and subject to amendment.

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
