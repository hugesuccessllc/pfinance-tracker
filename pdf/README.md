# /pdf: Campaign Slick Sheets

This directory builds **print-ready campaign literature** from findings this repo has
already published. It is governed by different rules than the rest of the repository,
and this file is those rules.

Current output: `build-slicksheet.rb` → a two-page, double-sided US-Letter portrait
sheet on August Pfluger's campaign finances, for the Claire Reynolds for Congress
campaign (TX-11).

```bash
ruby pdf/build-slicksheet.rb
# → pdf/output/claire-reynolds-slicksheet.pdf

ruby pdf/build-slicksheet.rb --out /tmp/preview.pdf          # write somewhere else
ruby pdf/build-slicksheet.rb --copy /tmp/alt-wording.md      # try different copy
ruby pdf/build-slicksheet.rb --generated-at 2026-08-16       # reproduce an old stamp
```

Run it as plain `ruby`, **not** `bundle exec ruby`. `lib/bootstrap.rb` pins
`BUNDLE_GEMFILE` to `pdf/Gemfile` itself, exactly like `/tooling` does, and `bundle exec`
sets that variable first and breaks the pin. See `lib/bootstrap.rb` for the full
explanation.

---

## Where things live

Three inputs, one job each. **If you only want to change wording, you only touch the
first one.**

| File | Holds | Edit it when |
|---|---|---|
| `copy/slicksheet.md` | **Every word printed on the sheet.** Headlines, captions, steps, glossary, footer. | Reworking wording, tone, or a headline. |
| `data/figures.yml` | **Every number**, each with the published report it came from. Plus the short label naming each chart mark. | A source report is refreshed. |
| `build-slicksheet.rb` | **Layout only.** Positions, sizes, page geometry. No prose, no arithmetic on totals. | Moving something on the page. |

A copy edit is: open `copy/slicksheet.md`, change the text under a `##` slot, re-run the
build. No Ruby, no chart code, no recalculation, and nothing else on the page moves.

The one deliberate exception is chart-mark labels ("Fine dining", "Oil & Gas"), which
stay in `figures.yml` beside the value they name. Splitting a label from its number
across two files is how the two quietly drift apart.

---

## Why this directory has its own rules

Everything under `tx-*/` is analysis written for a reader who wants to check the work:
it cites file paths and line numbers, discloses its own methodology, and says plainly
where it might be wrong. That is the right format for a report and the wrong format for
a mailer.

This directory produces the other thing, a piece of campaign literature handed to a
voter who has never opened a spreadsheet. Different audience, different rules.

---

## The rules

### 1. Never use an em-dash

Not once, anywhere on the sheet. Readers have grown to hate them, and a lot of people
now read any em-dash as a tell for lazy AI-written copy. On a piece whose entire
argument is "these are real, checkable numbers," looking machine-generated costs more
than the punctuation is worth.

The fix is not to swap in a different dash. It is to **write sentences that do not need
one.** An em-dash almost always means two thoughts got spliced together; split them.

```
no    A single oil executive gave $642,100 — more than every other donor combined.
yes   A single oil executive gave $642,100. Every other donor, combined, gave less.

no    Luxury spending climbed every cycle — from 0.30% to 7.22%.
yes   Luxury spending climbed every cycle, from 0.30% to 7.22%.
```

Ranges take a word, not a dash: "$15,001 to $50,000", "2020 through 2026".

**This is enforced, not merely requested.** `CopyDeck` refuses to load a copy file
containing one and names the offending slot, and `SlickSheet#text_box` raises on any
string composed at runtime. A build that would print an em-dash fails instead. Confirm
against the finished artifact too:

```bash
pdftotext pdf/output/claire-reynolds-slicksheet.pdf - | grep -c "—"   # expect 0
```

### 2. Every sheet carries a generated-on date

The footer of **both** pages prints `Generated <Month D, YYYY>`. Campaign literature
outlives the filing period it describes, and someone holding a printed copy needs to
know whether it predates newer FEC filings. It also tells you which run a stack of
leftover sheets came from.

The stamp comes from the build clock. Pass `--generated-at YYYY-MM-DD` to reproduce an
earlier run exactly, such as when reprinting a sheet that already went to a printer.

```bash
pdftotext pdf/output/claire-reynolds-slicksheet.pdf - | grep -c "Generated"   # expect 2
```

### 3. Never mention this repository, its tooling, or AI

Nothing in the generated PDF may reference this repo, `analyze-candidate.rb`, any LLM
or AI involvement, or the analysis process. The audience is a general voter; none of
that context is useful to them, and on a campaign mailer it is actively distracting.

The build script has no such strings in it, and the check is mechanical. Run this
before shipping any PDF from this directory:

```bash
pdftotext pdf/output/claire-reynolds-slicksheet.pdf - \
  | grep -ciE "claude|\bLLM\b|AI-generated|pfinance|repository|ruby|prawn|github"
# expected: 0
```

Note "Anthropic" appears on page 2 **as a suggested donor search term**. It is a real
employer in Pfluger's FEC donor records, which is the only reason it is there. Don't
let that trip the check above, and don't remove it.

### 4. No new analysis happens here

Every figure lives in `data/figures.yml`, and every figure in that file carries a
`source:` naming the already-published report it came from. `build-slicksheet.rb` reads
that file and never computes a finding of its own. It does not open a CSV, does not
call `analyze-candidate.rb`, and does not do arithmetic on a total.

**If a number you want isn't already in a published report, go write or update that
report first.** That keeps this directory from quietly becoming a second, uncited
analysis pipeline whose numbers drift away from the reports they claim to summarize.

When source reports get refreshed with new data, update `data/figures.yml` and its
`source:` lines, then re-run the build. The repo's standing "reports are not diffs"
rule applies to the sheet's own copy too: it should always read as a first-time
statement of the current numbers, never as a changelog against a previous printing.

### 5. Legal requirements, not design preferences

Two elements are compliance items and must not be "cleaned up" in a redesign:

- **"Paid for by Claire Reynolds for Congress"**, at 8pt, inside a drawn box, on **both**
  pages. Handled by `draw_footer`, which is called on each page.
- **The `https://claire11.org` QR code** appears **exactly once**, on page 1 only,
  in the masthead. Drawn as vector squares (`lib/qr_helper.rb`) rather than an embedded
  image so it stays sharp at any print resolution, with a 4-module white quiet zone so
  scanners can find it.

Verify the QR actually resolves after any layout change. A QR that renders but does not
decode is worse than none:

```bash
pdftoppm -png -r 300 -f 1 -l 1 pdf/output/claire-reynolds-slicksheet.pdf /tmp/qr
zbarimg --quiet /tmp/qr-1.png     # expected: QR-Code:https://claire11.org
```

### 6. Use the campaign's colors

The palette is the campaign's own, taken from the stylesheet at
<https://www.clairereynoldsforcongress.org/press-kit> and confirmed by sampling the
published logo artwork (roughly two-thirds of colored logo pixels fall in the indigo
family, with gold as the single accent). All values live in `lib/chart_helpers.rb`.

| Role | Hex | Notes |
|---|---|---|
| Brand primary dark | `#212355` | Mastheads, closing band. The site's most-used color. |
| Brand indigo (as published) | `#333794` | Panel top rules. Chrome only. |
| **Series indigo** | `#6064c8` | **The default data mark.** Every bar, every trend line. |
| **Accent gold** | `#d87e05` | **Highlight marks only.** The one bar a chart argues about. |
| Brand gold (as published) | `#faa533` | Reference. Not used as a mark. See below. |
| Pale tint | `#e8f0ff` | Callout backgrounds, body text on navy. |
| Light indigo | `#a9acdc` | Eyebrow text on navy. |
| Panel plane | `#f5f7fe` | Infographic card background. |
| Ink | `#16162e` / `#4a4a63` / `#8a8a9c` | Primary / secondary / muted text. |

**Why the data marks use mid-steps instead of the brand colors as published.** The
brand indigo `#333794` and gold `#faa533` were both checked against white paper with a
colorblind-safety validator and both failed as *data marks*: the indigo is darker than
the usable mark-lightness band, the gold lighter than it, and the gold sits at only 2:1
contrast on white, so it would wash out in print. The mid-steps `#6064c8` and `#d87e05`
are themselves in the campaign's own stylesheet, and together they clear every gate
(CVD ΔE 28.3 and normal-vision ΔE 31.7 against floors of 8 and 15; both above 3:1
contrast on white). The unmodified brand colors are still used, as chrome: mastheads
and rules, which are not held to that bar because chrome never encodes a value.

If the campaign's palette changes, re-validate before shipping. Don't eyeball it.

### 7. Chart rules that keep the sheet honest

These are documented at length in `lib/chart_helpers.rb`; the short version:

- **One color per series.** Every bar in a chart is `SERIES_INDIGO`. Categories here
  (spending destinations, industries, states) have no natural order, so a
  darker-where-bigger ramp would double-encode length as hue and burn the only free
  visual channel restating what bar length already says. `ACCENT_GOLD` marks the single
  bar a chart is making an argument about, never a second series.
- **Text never wears the data color.** Marks are colored; labels and values are ink.
- **Don't put different kinds of money on one scale.** Infographic 1 charts four FEC
  *operating-spend* categories that share a scale honestly. An earlier draft mixed the
  JFC's inter-committee transfers into the same chart. Those are transfers, not
  operating spend, and putting them on one axis overstated the comparison. That story
  moved to the narrative band instead.
- **Percentages keep their own denominators, and if they diverge, fix the report, not
  the sheet.** Every industry share currently sits on the same $5,317,758.43 base, and
  the panel footnote says so. They didn't always: the data-center report once ran on
  older exports covering three of four committees, putting its share on a $5,257,758.43
  base. The fix was to regenerate that report, **not** to re-divide its numerator here.
  re-basing a percentage inside `/pdf` would be deriving a finding, which rule 4
  forbids, and it would have been wrong anyway, since the refreshed scan also moved the
  numerator ($125,500 → $130,500). When denominators disagree, that is a signal a source
  report is stale. Check what each report cites with:
  ```bash
  grep -oE "schedule_[ab]-2026-[0-9]{2}-[0-9]{2}" tx-11/august-pfluger/reports/*.md | sort -u
  ```
  Report *dates* are not a reliable staleness signal. The stale data-center report was
  dated the same day as the current ones. The cited export filenames are.

### 8. Ruby, own Gemfile, same conventions as /tooling

`prawn` for PDF drawing and `rqrcode` for the QR matrix. Charts are drawn by hand in
`lib/chart_helpers.rb` on Prawn primitives, because every Ruby charting gem either needs
Cairo/ImageMagick native extensions or rasterizes to an image that prints soft.

Treat everything in `pdf/output/` as a build artifact: regenerate it from the script,
never hand-edit the PDF. Whether the artifact is version-controlled is a separate call.
if you do commit one, re-run the build and the verification checks below first, so the
committed file actually matches the current `figures.yml`.

---

## Files

| Path | What it is |
|---|---|
| `copy/slicksheet.md` | **Every word on the sheet.** Start here for a wording change. |
| `data/figures.yml` | Every number on the sheet, each with its source report. |
| `build-slicksheet.rb` | Page layout. The only entry point. |
| `lib/copy_deck.rb` | Parses the copy deck. Enforces the no-em-dash rule at load. |
| `lib/bootstrap.rb` | `BUNDLE_GEMFILE` pin, so plain `ruby` resolves this dir's gems. |
| `lib/chart_helpers.rb` | Palette, mark specs, bar/line/stat/panel primitives. |
| `lib/qr_helper.rb` | QR code drawn as vector squares. |
| `output/` | Generated PDFs. Build artifacts. |

---

## Verifying a build

```bash
ruby pdf/build-slicksheet.rb
PDF=pdf/output/claire-reynolds-slicksheet.pdf

pdfinfo $PDF | grep -E "Pages|Page size"           # 2 pages, letter portrait
pdftotext $PDF - | grep -c "—"                     # rule 1: expect 0
pdftotext $PDF - | grep -c "Generated"             # rule 2: expect 2
pdftotext $PDF - | grep -ciE "claude|\bLLM\b|AI-generated|pfinance|repository|ruby|prawn|github"
                                                   # rule 3: expect 0
pdftotext $PDF - | grep -c "Paid for by"           # rule 5: expect 2

pdftoppm -png -r 300 $PDF /tmp/qr
zbarimg --quiet /tmp/qr-1.png                      # rule 5: the claire11.org URL
zbarimg --quiet /tmp/qr-2.png                      # rule 5: expect no QR on page 2

# then look at it. None of the above catches a collision or a clipped label
pdftoppm -png -r 110 $PDF /tmp/page
```

Then confirm by eye: no overlapping text or charts; both disclaimer boxes present and
legible; every figure matches its `source:` report; and print it double-sided once
before ordering a run.

---

## Provenance

**Model and harness.** Built with Claude Sonnet 5 (`claude-sonnet-5`) running as the
Claude Code agent in a VS Code extension session, on behalf of Tod Beardsley, on
2026-08-16. Default harness settings; no custom temperature or token limits. This note
is here because the repo documents how its artifacts were produced. It is deliberately
**not** in the generated PDF, per rule 3.

**Source reports** this sheet draws from, all under `tx-11/august-pfluger/`:
`README.md` (2026 summary), `reports/2026-luxury-spending.md`,
`reports/2026-outside-texas.md`, `reports/2026-oil-and-gas.md`,
`reports/2026-datacenters.md`, `reports/2026-automotive.md`.

**Originating prompt** (2026-08-16, lightly trimmed for length):

> We have an overview of Pfluger's campaign finance which shows he's well-funded for
> the 2026 race in the newly redistricted TX-11. We have several breakout reports
> covering luxury spending, and his donation base outside of Texas, as well his received
> donations from automotive, AI datacenters, and of course oil & gas.
>
> I would like to craft a two-page PDF "slick sheet" with three infographics that tells
> the story of a rich guy from a rich family who is in Congress not to protect the
> interests of his poor to middle class constituents, but to enrich his donors (in and
> outside Texas) and himself. He is ambitious and his campaign funds aren't so much
> about fighting for his seat on ideological grounds, but as a power base for the
> future, getting even richer along the way.
>
> The first page should be this narrative and story, with specific graphs and figures.
> The reverse page should be a (very) simplified guide to how the reader can check this
> for themselves by going to FEC.gov (similar to how this top-level README explains the
> data gathering step), and notations to specific FEC reports and guidance on how to
> search donor and disbursements, with examples like Syed Javaid Anwar, the Capital
> Grille, Anthropic, and Toyota, to cover oil & gas, luxury disbursements, and AI and
> automotive support.
>
> Nothing in this slick sheet should mention this repo or the use of AI. The audience is
> not technically savvy enough to make use of that information. It should be a purely
> data-driven narrative of an oligarch building personal power at the expense of his
> voters.
>
> This is probably a three step process: Build the narrative that identifies the
> headline takeaways from the reports already written, short enough to fit on maybe half
> a page. Then, supporting infographics, charts, and graphs (maybe four total covering
> four areas of interest). Finally, a Ruby script that builds out the PDF itself: two
> 8 1/2 x 11 pages, landscape or portrait (whatever makes sense with the graphic
> layout), printable as a single double-sided page. Oh, and very important: It must have
> Paid for By Claire Reynolds for Congress in a normal font (can be 8-point), in a box,
> somewhere on the page (front and back). There should also be a QR code leading to
> https://claire11.org in one corner (only one side).
>
> This is merely planning. We probably want to save this under its own directory —
> /pdf is fine. This does not follow the normal rules for this repo's reporting in the
> README.md, as it's a different project, so let's create some rules in the README.md
> under /pdf once we have the plan down.

**Follow-up prompts** in the same session:

> Use the color palette found at https://www.clairereynoldsforcongress.org/press-kit for
> all coloring where it makes sense.

> You can infer the palette by sampling the various campaign logos.

> In this /pdf/README.md, record the prompts used, the model and harness, and the rules
> we've come up with (no mention of AI, the required Paid For blurb in a box, stick to
> campaign colors (name them), so we can re-run this kind of thing with updated data
> later.

> Rerun the PDF generation, ensuring that figures.yml is updated with the refreshed
> datacenter report. Otherwise, follow all the normal rules for PDF generation, as noted
> in pdf/README.md

> New rule for the pdf generation. Never ever use em-dashes. Create coherent sentences
> that don't need an em-dash to break up a thought. People have grown to hate em-dashes
> and now believe that any use of them indicates lazy AI authorship.
>
> Update the README.md with this rule, and regenerate the PDF with the new text.
>
> In fact, we should save off the text as its own editable markdown file, so small tweaks
> can be made by the human operator without having to regenerate the entire PDF every
> time without changing graphs, recalucating anything, etc.
>
> So, once the README.md is done with this new rule, adjust the workflow so that
> paragraph text ends up in a normal place as markdown. Then, the PDF should be assembled
> from that markdown source along with the sources for graphs and such.

> Ensure also (and make this a rule) that the PDF carries a generated-on timestamp.

**Decisions made during the build** that a future run should know about, since they
came from reviewing rendered output rather than from the prompt:

- The narrative band started at five bullets and was cut to three. Three of the five
  restated the four infographics directly below them in prose. The reader met the same
  figure twice, and the duplication cost the panels the vertical space they needed.
  The surviving three carry what the charts can't: the size of the war chest, the single
  donor who dominates it, and Pfluger's own March 2026 stock purchases.
- Infographic 1 was re-scoped from a JFC transfer funnel to a single operating-spend
  category comparison, for the honesty reason in rule 7.
- Page 2 gained a three-term glossary and a closing band. The first draft's steps left
  roughly a third of the page empty, and the steps used jargon ("joint fundraising
  committee," "disbursement") a first-time reader would hit on FEC.gov anyway.
- Bullet spacing uses `SlickSheet#measured_height`, not Prawn's `height_of`. `height_of`
  reported two lines (21.7pt) for all three narrative bullets when the first actually
  renders as one 7.4pt line, which left a visibly larger gap under the shortest bullet.
  Dry-running the same `Text::Formatted::Box` that performs the real render gives the
  height that will actually be drawn. Reach for `measured_height` for any new
  variable-length copy block, or the spacing will drift as wording changes.
- This README's own prose was cleaned of em-dashes when rule 1 landed. A rules document
  that bans them while being full of them invites a reader to assume the rule is
  decorative. The exceptions left in place are the two counter-examples under rule 1,
  the `grep` literal, and the verbatim prompts above, which are quoted as written and
  must not be edited.
