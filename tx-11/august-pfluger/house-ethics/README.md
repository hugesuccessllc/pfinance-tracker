# TX-11: August Pfluger — House Ethics Filings Inventory

This directory holds financial disclosures for Rep. August Pfluger (TX-11), filed with the
Clerk of the House of Representatives / House Committee on Ethics under the Ethics in
Government Act and the STOCK Act. Each entry below is one filing, identified by its House
Clerk **Filing ID** (the number printed in the header of every page of the PDF itself).

Three filing types appear here:

- **FD (Financial Disclosure Report)** — the annual report of assets, unearned income
  (interest, dividends, rent, capital gains), and outside positions. Covers a full calendar
  year and is filed the following year (a "New Filer Report" the first time, "Annual Report"
  thereafter).
- **PTR (Periodic Transaction Report)** — a STOCK Act disclosure of an individual securities
  transaction (purchase, sale, or exchange), due within 30–45 days of the trade.
- **Extension Request** — a request for up to a 90-day extension on an FD's filing deadline.

## Annual Financial Disclosure Reports

| File | Filing ID | Covers | Filed | Pages |
|---|---|---|---|---|
| [2021-08-09-pfluger-house-disclosure.pdf](2021-08-09-pfluger-house-disclosure.pdf) | 10041977 | CY2020 (New Filer Report) | 08/09/2021 | 5 |
| [2022-08-12-pfluger-house-disclosure.pdf](2022-08-12-pfluger-house-disclosure.pdf) | 10047683 | CY2021 | 08/12/2022 | 7 |
| [2023-08-06-pfluger-house-disclosure.pdf](2023-08-06-pfluger-house-disclosure.pdf) | 10052660 | CY2022 | 08/06/2023 | 7 |
| [2024-08-12-pfluger-house-disclosure.pdf](2024-08-12-pfluger-house-disclosure.pdf) | 10059397 | CY2023 | 08/12/2024 | 6 |
| [2025-08-13-pfluger-house-disclosure.pdf](2025-08-13-pfluger-house-disclosure.pdf) | 10066262 | CY2024 | 08/13/2025 | 7 |
| [2026-08-12-pfluger-house-disclosure.pdf](2026-08-12-pfluger-house-disclosure.pdf) | 10075620 | CY2025 | 08/12/2026 | 7 |

Each covers bank accounts, real estate (Cranbrook Forest LLC, Silver Creek Rental, DC
rental property), family LLCs (Pfluger Herefords, Gentry Creek Energy, Code of the West
Coffee, PMP Spirits, Pfluger Energy Investments), and personal/spousal IRA stock and fund
holdings.

## Extension Request

| File | Filing ID | For | Requested | New due date |
|---|---|---|---|---|
| [2026-04-14-pfluger-extension-request.pdf](2026-04-14-pfluger-extension-request.pdf) | 30026980 | CY2025 FD (90 days) | 04/14/2026 | 08/13/2026 |

Covers the same CY2025 report as `2026-08-12-pfluger-house-disclosure.pdf` above, which was
in fact filed 08/12/2026 — one day inside the extended deadline.

## Periodic Transaction Reports (STOCK Act)

| File | Filing ID | Transaction date(s) | Filed | Summary |
|---|---|---|---|---|
| [2026-01-20-pfluger-ptr-liberty-media.pdf](2026-01-20-pfluger-ptr-liberty-media.pdf) | 20033804 | 12/16/2025 | 01/20/2026 | Merger-related exchange: Liberty Media Corp. Series C → Liberty Formula One (FWONK) and Liberty Live (LLYVK) shares, CP Roth IRA, $1,001–$15,000 each |
| [2026-02-11-pfluger-ptr-fnf-siri.pdf](2026-02-11-pfluger-ptr-fnf-siri.pdf) | 20033920 | 01/12–01/13/2026 | 02/11/2026 | Sale: Fidelity National Financial (FNF), Roth IRA; Sale: SiriusXM (SIRI), CP Roth IRA — $1,001–$15,000 each |
| [2026-03-19-pfluger-ptr-wbd.pdf](2026-03-19-pfluger-ptr-wbd.pdf) | 20034054 | 02/10/2026 | 03/19/2026 | Sale: Warner Bros. Discovery (WBD), Roth IRA, $1,001–$15,000 |
| [2026-04-15-pfluger-ptr-uhalb-brkb-dmlp-epd-krp-vnom.pdf](2026-04-15-pfluger-ptr-uhalb-brkb-dmlp-epd-krp-vnom.pdf) | 20034348 | 03/13/2026 | 04/15/2026 | Purchases in an "Investment" account: Amerco (UHALB), Berkshire Hathaway (BRK.B), Dorchester Minerals (DMLP), Enterprise Products Partners (EPD), Kimbell Royalty Partners (KRP), Viper Energy (VNOM) — $15,001–$50,000 each |

## Where these come from

All filings are public and hosted by the Clerk's Office at **disclosures-clerk.house.gov**.

**To search/browse interactively:**
1. Go to <https://disclosures-clerk.house.gov/FinancialDisclosure>
2. Click **Search**
3. Choose **Member** (not Candidate — Pfluger's filings are under his sitting-member record)
4. Enter last name `Pfluger`, pick the year(s) of interest, and search
5. Each result row links to that filing's PDF

**Direct PDF URLs** follow a predictable pattern keyed by Filing ID and a year subdirectory —
useful for scripting future downloads. Every URL below was fetched and spot-checked (page
count + the Filing ID printed on the PDF itself) against the local copy to confirm the
pattern:

- **FD reports and extension requests:**
  `https://disclosures-clerk.house.gov/public_disc/financial-pdfs/<YEAR>/<FILING_ID>.pdf`
  — `<YEAR>` is the **year the report covers** (the "Filing Year" field inside the document),
  not the year it was actually filed. E.g. the CY2022 report (filed in 2023, Filing ID
  10052660) lives under `.../financial-pdfs/2022/10052660.pdf`.

- **PTRs:**
  `https://disclosures-clerk.house.gov/public_disc/ptr-pdfs/<YEAR>/<FILING_ID>.pdf`
  — here `<YEAR>` is the year the PTR was **filed/signed**, e.g.
  `.../ptr-pdfs/2026/20033804.pdf` for a report signed 01/20/2026 even though the underlying
  trade happened 12/16/2025.

Full list, for reference:

```
https://disclosures-clerk.house.gov/public_disc/financial-pdfs/2020/10041977.pdf
https://disclosures-clerk.house.gov/public_disc/financial-pdfs/2021/10047683.pdf
https://disclosures-clerk.house.gov/public_disc/financial-pdfs/2022/10052660.pdf
https://disclosures-clerk.house.gov/public_disc/financial-pdfs/2023/10059397.pdf
https://disclosures-clerk.house.gov/public_disc/financial-pdfs/2024/10066262.pdf
https://disclosures-clerk.house.gov/public_disc/financial-pdfs/2025/10075620.pdf
https://disclosures-clerk.house.gov/public_disc/financial-pdfs/2025/30026980.pdf
https://disclosures-clerk.house.gov/public_disc/ptr-pdfs/2026/20033804.pdf
https://disclosures-clerk.house.gov/public_disc/ptr-pdfs/2026/20033920.pdf
https://disclosures-clerk.house.gov/public_disc/ptr-pdfs/2026/20034054.pdf
https://disclosures-clerk.house.gov/public_disc/ptr-pdfs/2026/20034348.pdf
```

Note the year-folder rule differs between the two document types (report-period year for FDs,
filed-year for PTRs) — don't assume one pattern covers both when constructing new URLs by
hand.
