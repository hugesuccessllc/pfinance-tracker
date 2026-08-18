# Slick sheet copy

Every word that appears on the printed sheet lives in this file. Edit the text here, re-run `ruby pdf/build-slicksheet.rb`, and the new wording appears in the PDF. Nothing in this file changes a chart, a number, or a calculation.

**Two hard rules, both enforced by the build:**

1. **No em-dashes.** Not anywhere, not once.

Write sentences that stand on their own instead of splicing two thoughts together with a dash. The build refuses to run if it finds one, and tells you which slot it is in.

2. **Numbers stay in `data/figures.yml`.**

Prose here may quote a figure, but every figure quoted below is recorded in that file's `cited_in_copy:` ledger along with the published report it came from. If you change a quoted number here, update its ledger entry too, or the sheet will contradict the reports it claims to summarize.

Watch the **scope** of a figure especially: several totals in the source reports cover every cycle since 2020, not the current one. The Capital Grille figure is the standing example. Say "since 2020" when that is what the number means.

**Non-FEC facts** (election dates, statutes) do not go in `figures.yml`'s citation ledger, since that is scoped to already-published campaign-finance reports and there is no report to write for a date fixed by law. Cite the source inline in the sentence instead, the way `cta.body`'s voting dates cite Texas Election Code Section 85.001. That date was verified against the bill text of 2025's SB 2753 before being printed: SB 2753 shortens early voting from 17 days before election day to 12, but only for an election ordered after the Secretary of State publishes a certification report required by that bill, which is not due until August 1, 2027. The November 2026 general election falls before that report, so the pre-SB-2753 17-day rule controls: early voting October 17 through 30, 2026, Election Day November 3. Re-check this before reusing the copy for any election in 2027 or later, since the 12-day rule may be in force by then.

Headings marked `##` are slot names the build script looks up. Do not rename or remove them. Under a slot, `###` sub-headings become titled entries (steps, glossary terms, search examples), a `-` list becomes bulleted lines, and anything else is plain text. `**bold**` renders as bold.

Ordinary line-wrapping in this file (breaking a long line so it is readable in a diff) is invisible in the output: those newlines collapse back into flowing prose. To force a real line break instead, such as splitting a headline across two lines on purpose, end the line with a single backslash, the way `masthead.headline` does below. Do not use a blank line for this: a blank line starts a new paragraph, which prints with visibly more gap than a plain line break.
---

## masthead.eyebrow

FOLLOW THE MONEY  ·  TEXAS' 11TH CONGRESSIONAL DISTRICT

## masthead.headline

Everyone got a piece of August Pfluger's millions.\
Everyone except the people of TX-11.

## masthead.dek

Four committees. $5.3 million.
A donor list that reaches from Midland oil money to Washington power brokers.\
Here is where that money comes from, and where it actually goes.

## narrative.heading

THE STORY IN THREE NUMBERS

## narrative.bullets

- **$5.3 million** raised across four separate committees in this cycle alone.
  That is a war chest built to entrench a career, not to fight for one election.
- A single Midland oil executive, Syed Javaid Anwar, gave the Pfluger Victory Fund **$642,100** this election cycle. That equals, almost to the dollar, the total given by every donor to August Pfluger for Congress.
- In March 2026, Pfluger personally bought up to **$50,000** worth of stock in each of six companies, three of them oil and gas, while sitting on the House committee that writes their rules.
## panel.spending.title

Where the Money Actually Goes

## panel.spending.subtitle

Operating spending across all four Pfluger committees, 2026 cycle.
Every bar below comes from the same spending breakdown, on the same scale.

## panel.spending.caption

Pfluger sent eight times more money to other GOP candidates than he spent on reaching out to his own TX-11 voters to make the case for his own election.

## panel.industry.title

Who's Buying Access

## panel.industry.subtitle

Three industries with business before Pfluger's committee assignments all made sure to donate generously to Pfluger's campaign in the 2026 cycle.

## panel.industry.caption

Pfluger sits on the House Energy and Commerce Committee, which holds direct jurisdiction
over energy, telecom, and utility policy.
All three of these industries have real business before that seat, and all three are in
his donor rolls.

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

since 2020 on dining, resorts, chauffeured cars, and donor gifts. $583,137 of that came in
this cycle alone.

## panel.luxury.caption

The venues tell the story.
A Deer Valley ski lodge, the Ritz-Carlton, a private golf club with a $150,000 initiation
fee, and 125 visits to a single upscale steakhouse chain, The Capital Grille. (To be fair, he did spend $756.42 at the Springhill Restaurant during his single visit to Pflugerville in 2025.)

## panel.geography.title

Piped In, Not From Here

## panel.geography.subtitle

Out-of-state contributions have taken over his campaign since his first race.

## panel.geography.stat_label

of every contribution this cycle came from outside Texas.

## panel.geography.chart_label

TOP OUT-OF-STATE SOURCES, BY DOLLARS RAISED

## panel.geography.caption

In his first race, just 14.8% of contributions came from outside Texas. This cycle,
it's 84.4%.

## verify.eyebrow

DON'T TAKE OUR WORD FOR IT

## verify.headline

Check Every Number Yourself

## verify.dek

Federal law requires every campaign to publish who gives it money and how that money is spent.\
It's all free, all public, and it takes about five minutes to start browsing. Here's how.

## verify.steps

### Go to fec.gov/data

This is the Federal Election Commission, the government agency that collects campaign
finance filings. There is no login, no account, and no cost.
Type "August Pfluger" into the search box at the top.

### Find the committees

A candidate can have several. August Pfluger has four.
Three carry real money: his campaign committee, his "Pfluger Victory Fund" (which collects
the largest checks), and his leadership PAC, "Raptor PAC." The fourth barely moved any
money in this cycle.
All four ID numbers are listed below, so you can go straight to any of them at
fec.gov/data/committee/ plus the ID.

### To see who donated money, click "Receipts"

This lists every contribution above $200, with the donor's name, city, employer, and
occupation. Use the filters to search a name or an employer.

### To see what those donations were spent on, click "Disbursements"

This lists every payment the campaign made: the vendor, the amount, the date, and what it
was for. Search a business name to see every charge to it.

## verify.committees_heading

THE FOUR COMMITTEE ID NUMBERS

## verify.glossary_heading

THREE TERMS YOU'LL RUN INTO

## verify.glossary

### Joint fundraising committee

Lets several committees raise money together, so one donor can legally write a check far
larger than any single campaign could accept.

### Leadership PAC

A second fund a politician controls. It cannot pay for their own race.
It exists to give money to other candidates and build influence.

### Disbursement

Any payment a campaign makes: a vendor, a plane ticket, a dinner, a donation to another
candidate.

## verify.searches_heading

FOUR SEARCHES THAT TELL THE STORY

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

Look it up, and decide for yourself who will actually work for TX-11.

## cta.body

Every figure on the front of this sheet comes from these public filings.
Check any one of them, then visit claire11.org.

Early voting runs October 17 through 30, 2026. Election Day is November 3 (Texas Election Code, Section 85.001). Make a plan to vote. Know your rights, know your polling place, and know when you are going.

## footer.disclaimer

Paid for by Claire Reynolds for Congress

## footer.source_note

Source: FEC.gov campaign finance filings covering 2020 through 2026, committees C00719294,
C00753913, C00749481, and C00840033.

## footer.turn_over

Turn over to check these numbers yourself.

## footer.site

To learn more about Claire Reynolds, visit claire11.org.
