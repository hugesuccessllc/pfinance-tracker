# Slick sheet copy

Every word that appears on the printed sheet lives in this file. Edit the text here,
re-run `ruby pdf/build-slicksheet.rb`, and the new wording appears in the PDF. Nothing
in this file changes a chart, a number, or a calculation.

**Two hard rules, both enforced by the build:**

1. **No em-dashes.** Not anywhere, not once. Write sentences that stand on their own
   instead of splicing two thoughts together with a dash. The build refuses to run if it
   finds one, and tells you which slot it is in.
2. **Numbers stay in `data/figures.yml`.** Prose here may quote a figure, but every
   figure quoted below is recorded in that file's `cited_in_copy:` ledger along with the
   published report it came from. If you change a quoted number here, update its ledger
   entry too, or the sheet will contradict the reports it claims to summarize.

   Watch the **scope** of a figure especially: several totals in the source reports cover
   every cycle since 2020, not the current one. The Capital Grille figure is the standing
   example. Say "since 2020" when that is what the number means.

Headings marked `##` are slot names the build script looks up. Do not rename or remove
them. Under a slot, `###` sub-headings become titled entries (steps, glossary terms,
search examples), a `-` list becomes bulleted lines, and anything else is plain text.
`**bold**` renders as bold.

---

## masthead.eyebrow

FOLLOW THE MONEY  ·  TEXAS' 11TH CONGRESSIONAL DISTRICT

## masthead.headline

August Pfluger Isn't Fighting for TX-11. He's Building an Empire.

## masthead.dek

Five committees. $5.3 million. A donor list that reaches from Midland oil money to
Washington power brokers. Here is where that money comes from, and where it actually
goes.

## narrative.heading

THE STORY IN THREE NUMBERS

## narrative.bullets

- **$5.3 million** raised across four separate committees in this cycle alone. That is a
  war chest built to entrench a career, not to fight for one election.
- A single Midland oil executive gave **$642,100** through Pfluger's joint fundraising
  committee. Every donor to his actual campaign committee, combined, gave **$642,408.43**.
- In March 2026 he personally bought stakes of **$15,001 to $50,000** in six companies,
  three of them oil and gas, while sitting on the House committee that writes their rules.

## panel.spending.title

Where the Money Actually Goes

## panel.spending.subtitle

Operating spending across all four Pfluger committees, 2026 cycle. Every bar below comes
from the same spending breakdown, on the same scale.

## panel.spending.caption

He spent eight times more buying goodwill from other candidates than he spent talking to
his own voters, and seven times more raising money than advertising to them. A separate
$638,886.02 went straight to the national party.

## panel.industry.title

Who's Buying Access

## panel.industry.subtitle

Three industries with business before Pfluger's committee assignments, in one cycle of
giving.

## panel.industry.caption

Pfluger sits on the House Energy and Commerce Committee, which holds direct jurisdiction
over energy, telecom, and utility policy. All three of these industries have real
business before that seat, and all three are in his donor rolls.

## panel.industry.footnote

All three shares are calculated against the same figure: $5,317,758.43 in itemized donor
receipts across Pfluger's four committees for the 2026 election cycle.

## panel.luxury.title

Courting Donors, Not Constituents

## panel.luxury.subtitle

Fine dining, ski resorts, and private clubs take an ever growing share of every dollar
raised.

## panel.luxury.chart_label

SHARE OF ALL CAMPAIGN SPENDING, BY ELECTION CYCLE

## panel.luxury.strip

since 2020 on dining, resorts, chauffeured cars, and donor gifts. $583,137 of that came
in this cycle alone.

## panel.luxury.caption

The venues tell the story. A Deer Valley ski lodge, the Ritz-Carlton, a private golf club
with a $150,000 initiation fee, and 125 visits to a single steakhouse chain.

## panel.geography.title

A National Money Machine Wearing a Texas District's Name

## panel.geography.subtitle

Two out of every three donations Pfluger has ever taken came from outside Texas.

## panel.geography.stat_label

of all contributions, rising to 84.4% this cycle.

## panel.geography.chart_label

TOP OUT-OF-STATE SOURCES, BY DOLLARS RAISED

## panel.geography.caption

In his first race it was just 14.8%. The money now comes from everywhere but here.

## verify.eyebrow

DON'T TAKE OUR WORD FOR IT

## verify.headline

Check Every Number Yourself

## verify.dek

Federal law requires every campaign to publish who gives it money and how that money is
spent. It is all free, all public, and it takes about five minutes to look up. Here is
exactly how.

## verify.steps

### Go to fec.gov/data

This is the Federal Election Commission, the government agency that collects campaign
finance filings. There is no login, no account, and no cost. Type "August Pfluger" into
the search box at the top.

### Find his committees

A candidate can have several. Three matter here: his campaign committee, his "Pfluger
Victory Fund" (which collects the largest checks), and his leadership PAC, "Raptor PAC."
Their ID numbers are listed below. You can go straight to any of them at
fec.gov/data/committee/ plus the ID.

### To see who gave him money, click "Receipts"

This lists every contribution above $200, with the donor's name, city, employer, and
occupation. Use the filters to search a name or an employer.

### To see what he spent it on, click "Disbursements"

This lists every payment the campaign made: the vendor, the amount, the date, and what it
was for. Search a business name to see every charge to it.

## verify.committees_heading

THE THREE COMMITTEE ID NUMBERS

## verify.glossary_heading

THREE TERMS YOU'LL RUN INTO

## verify.glossary

### Joint fundraising committee

Lets several committees raise money together, so one donor can legally write a check far
larger than any single campaign could accept.

### Leadership PAC

A second fund a politician controls. It cannot pay for their own race. It exists to give
money to other candidates and build influence.

### Disbursement

Any payment a campaign makes: a vendor, a plane ticket, a dinner, a donation to another
candidate.

## verify.searches_heading

FOUR SEARCHES THAT SHOW YOU THE WHOLE STORY

## verify.searches

### Anwar, Syed

A single Midland oil executive's six-figure checks

### Anthropic

AI-industry employees among his donors

### Toyota

Automotive-industry PAC money

### Capital Grille

$90,570.39 across 125 visits since 2020 (search Disbursements)

## cta.headline

Look it up. Then decide who will actually work for TX-11.

## cta.body

Every figure on the front of this sheet comes from these public filings. Check any one of
them, then visit claire11.org.

## footer.disclaimer

Paid for by Claire Reynolds for Congress

## footer.source_note

Source: FEC.gov campaign finance filings covering 2020 through 2026, committees
C00719294, C00753913, and C00749481.

## footer.turn_over

Turn over to check these numbers yourself.

## footer.site

claire11.org
