#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "lib/bootstrap"

# build-slicksheet.rb — renders the two-page Claire Reynolds campaign slick sheet.
#
# USAGE (run as plain `ruby`, not `bundle exec ruby` — see lib/bootstrap.rb for why)
#   ruby pdf/build-slicksheet.rb
#   ruby pdf/build-slicksheet.rb --out /tmp/preview.pdf
#
# Output: two US-Letter portrait pages, designed to print as a single double-sided
# sheet. Page 1 is the argument (narrative band + four infographics); page 2 teaches
# a reader to verify all of it on FEC.gov themselves.
#
# THREE INPUTS, ONE JOB EACH:
#
#   copy/slicksheet.md   every word that appears on the sheet. Edit copy there.
#   data/figures.yml     every number, with the published report each came from.
#   this file            layout only. No prose literals, no arithmetic on totals.
#
# WHAT THIS SCRIPT WILL NOT DO (see pdf/README.md for the full rules):
#
#   * It never computes a finding. Every dollar figure and percentage is read from
#     data/figures.yml, where each one is recorded next to the already-published
#     report it came from. If a number needs to change, change it there, and if it
#     isn't in a published report yet, go write that report first.
#   * It never mentions this repository, its tooling, or how the analysis was
#     produced. The output is campaign literature for a general voter.
#   * It never prints an em-dash. Every string routes through #text_box below, which
#     raises on one, so the rule holds even for text composed here at runtime rather
#     than authored in the copy deck.
#
# Three elements are requirements, not design choices: the "Paid for by" disclaimer box,
# the generated-on timestamp, and the claire11.org QR code + campaign logo cluster all
# appear on BOTH pages, drawn identically via #draw_corner_graphics so the two mastheads
# mirror each other by construction.

require "prawn"
require "yaml"
require "optparse"
require "date"

# This sheet is about a Texas district; its printed date stamp means "Texas time," not
# "whatever timezone the build machine happens to be in." Set before any Time/Date call
# below runs, so File.mtime/Time.now/Date#to_time all resolve through the OS's own
# zoneinfo database for America/Chicago (DST-aware, no extra gem needed) rather than
# system-local time — matters most for a build that runs late evening Central time,
# which is already past midnight UTC and would otherwise print tomorrow's date.
ENV["TZ"] = "America/Chicago"

require_relative "lib/chart_helpers"
require_relative "lib/qr_helper"
require_relative "lib/copy_deck"

class SlickSheet
  include ChartHelpers
  include QrHelper

  PAGE_WIDTH  = 612.0
  PAGE_HEIGHT = 792.0
  MARGIN      = 32.0
  CONTENT_W   = PAGE_WIDTH - (MARGIN * 2)

  GRID_GAP    = 14.0
  CELL_W      = (CONTENT_W - GRID_GAP) / 2
  CELL_H      = 224.0

  FOOTER_TOP  = 92.0

  # Vertical space reserved at the bottom of each panel for its caption, so a chart
  # never grows into the sentence explaining it. Panel 2 carries a source footnote
  # under its caption and reserves more.
  CAPTION_RESERVE = 40.0

  # The report whose file mtime pins the "Data current as of" stamp by default (see
  # #generated_stamp and the --generated-at override below). Hardcoded, not a flag,
  # because this script only ever builds one sheet from one candidate's data — a second
  # sheet gets its own script, not a --source-report option here (see pdf/README.md).
  SOURCE_REPORT = File.expand_path("../tx-11/august-pfluger/README.md", __dir__)

  def initialize(figures, copy, out_path, generated_at:)
    @f = figures
    @c = copy
    @out_path = out_path
    @generated_at = generated_at
    @pdf = Prawn::Document.new(
      page_size: "LETTER",
      page_layout: :portrait,
      margin: 0,
      info: {
        Title: "August Pfluger: Follow the Money",
        Author: "Claire Reynolds for Congress",
        Creator: "Claire Reynolds for Congress",
        # The PDF's own CreationDate is a technical property of the file (when this
        # build actually ran) and is deliberately NOT tied to @generated_at, which
        # drives the printed "Data current as of" stamp below instead — see gotcha at
        # #generated_stamp for why those two dates are allowed to differ.
        CreationDate: Time.now
      }
    )
    @pdf.font "Helvetica"
  end

  def build
    page_one
    @pdf.start_new_page
    page_two
    @pdf.render_file(@out_path)
    @out_path
  end

  private

  # Every string drawn on the sheet passes through here. Two reasons it exists rather
  # than calling @pdf.text_box directly:
  #
  #   1. It enforces the no-em-dash rule on text composed at runtime (a bar label built
  #      from a figure, say), which the copy deck's own load-time check cannot see.
  #   2. It fails at build time with the offending string, instead of shipping a dash
  #      that nobody notices until the proof comes back from the printer.
  def text_box(content, **opts)
    string = content.to_s
    if string.include?(CopyDeck::EM_DASH)
      raise CopyDeck::EmDashError,
            "em-dash in text drawn by build-slicksheet.rb: #{string.inspect}. " \
            "Rewrite it as complete sentences."
    end

    @pdf.text_box(string, **opts)
  end

  # Deliberately about the DATA, not the PRINT RUN: @generated_at defaults to the source
  # report's own file mtime (see SOURCE_REPORT), not to whenever this script happened to
  # run, so the sheet asserts what it can actually back up — how current the underlying
  # numbers are — rather than a build timestamp a reader has no way to verify. Date only,
  # never a time of day; a voter doesn't need to know this ran at 9:47pm. --generated-at
  # still overrides it, e.g. to reproduce an already-printed run's stamp byte-for-byte.
  def generated_stamp = "Data current as of #{@generated_at.strftime('%B %-d, %Y')}"

  # Prawn's #height_of disagrees with what Text::Formatted::Box actually draws once
  # inline formatting is involved: it reported two lines (21.7pt) for all three
  # narrative bullets when the first one renders as a single 7.4pt line, which left a
  # visible extra gap beneath the shortest bullet. Dry-running the same box class that
  # performs the real render gives the height that will actually be drawn.
  def measured_height(content, width:, **opts)
    box = Prawn::Text::Formatted::Box.new(
      @pdf.text_formatter.format(content.to_s),
      width: width, height: 1_000, at: [0, @pdf.bounds.top], document: @pdf, **opts
    )
    box.render(dry_run: true)
    box.height
  end

  # ---------------------------------------------------------------- page 1

  def page_one
    grid_top = draw_masthead

    grid_top = draw_narrative(grid_top - 16)

    row1_y = grid_top - 14
    row2_y = row1_y - CELL_H - GRID_GAP

    draw_spending_panel([MARGIN, row1_y])
    draw_industry_panel([MARGIN + CELL_W + GRID_GAP, row1_y])
    draw_luxury_panel([MARGIN, row2_y])
    draw_geography_panel([MARGIN + CELL_W + GRID_GAP, row2_y])

    draw_footer(page_one: true)
  end

  def draw_masthead
    band_top = PAGE_HEIGHT
    band_h = 98.0
    band_bottom = band_top - band_h

    @pdf.fill_color DEEP_NAVY
    @pdf.fill_rectangle([0, band_top], PAGE_WIDTH, band_h)

    text_w = draw_corner_graphics(band_top: band_top) - MARGIN - 16

    @pdf.fill_color TINT_LIGHT
    text_box @c["masthead.eyebrow"],
                  at: [MARGIN, band_top - 16],
                  width: text_w,
                  height: 10,
                  size: 6.8,
                  style: :bold,
                  character_spacing: 0.9,
                  overflow: :shrink_to_fit

    @pdf.fill_color "FFFFFF"
    text_box @c["masthead.headline"],
                  at: [MARGIN, band_top - 30],
                  width: text_w,
                  height: 40,
                  size: 16,
                  style: :bold,
                  leading: 2,
                  overflow: :shrink_to_fit

    @pdf.fill_color PALE_BLUE
    text_box @c["masthead.dek"],
                  at: [MARGIN, band_top - 72],
                  width: text_w,
                  height: 24,
                  size: 7.4,
                  leading: 1.3,
                  overflow: :shrink_to_fit

    band_bottom
  end

  def draw_narrative(top_y)
    @pdf.fill_color INK_PRIMARY
    text_box @c["narrative.heading"],
                  at: [MARGIN, top_y],
                  width: CONTENT_W,
                  height: 11,
                  size: 8,
                  style: :bold,
                  character_spacing: 0.8,
                  overflow: :shrink_to_fit

    @pdf.fill_color ACCENT_GOLD
    @pdf.fill_rectangle([MARGIN, top_y - 13], 34, 2)

    y = top_y - 22
    bullet_w = CONTENT_W - 16

    @c["narrative.bullets"].each do |text|
      h = measured_height(text, width: bullet_w, size: 8, leading: 1.6)

      @pdf.fill_color SERIES_INDIGO
      @pdf.fill_circle([MARGIN + 3, y - 4], 2.2)

      @pdf.fill_color INK_SECONDARY
      text_box text,
                    at: [MARGIN + 16, y],
                    width: bullet_w,
                    height: h + 2,
                    size: 8,
                    leading: 1.6,
                    inline_format: true,
                    overflow: :shrink_to_fit

      y -= h + 5
    end

    y
  end

  def draw_spending_panel(at)
    data = @f["infographic_1"]
    content_y = panel(@pdf, title: @c["panel.spending.title"],
                            subtitle: @c["panel.spending.subtitle"],
                            at: at, width: CELL_W, height: CELL_H)

    x = at[0] + 12
    inner_w = CELL_W - 24

    bars = data["bars"].map do |bar|
      {
        label: bar["label"],
        value: bar["value"],
        color: bar["highlight"] ? ACCENT_GOLD : SERIES_INDIGO
      }
    end

    horizontal_bars(@pdf, bars: bars, at: [x, content_y - 2], width: inner_w, row_height: 26)

    panel_caption(@pdf, @c["panel.spending.caption"],
                  at: [x, at[1] - CELL_H + CAPTION_RESERVE], width: inner_w, height: 34)
  end

  def draw_industry_panel(at)
    data = @f["infographic_2"]
    content_y = panel(@pdf, title: @c["panel.industry.title"],
                            subtitle: @c["panel.industry.subtitle"],
                            at: at, width: CELL_W, height: CELL_H)

    x = at[0] + 12
    inner_w = CELL_W - 24

    # Bars are scaled by share-of-receipts (the comparable quantity), with the dollar
    # figure carried in each bar's own label, so the visual encodes one measure and the
    # text supplies the other. Scaled against a fixed ceiling from figures.yml so the
    # smaller bars read honestly rather than being stretched to fill the panel.
    #
    # %g, not %.2f: each source report states its share to its own precision (oil and
    # gas to one decimal, the other two to two). Padding 25.2% out to "25.20%" would
    # claim a significant figure the report it came from never published.
    bars = data["rows"].map do |row|
      {
        label: "#{row['label']}: #{format('%g%%', row['pct'])} of all money raised",
        value: row["value"]
      }
    end

    max_dollar = data["rows"].first["denominator"] * (data["scale_max_pct"] / 100.0)

    horizontal_bars(@pdf, bars: bars, at: [x, content_y - 4], width: inner_w,
                          row_height: 29, max_value: max_dollar)

    # This panel reserves more than CAPTION_RESERVE: it carries a source footnote
    # under its caption naming the shared denominator.
    caption_y = at[1] - CELL_H + 58
    panel_caption(@pdf, @c["panel.industry.caption"], at: [x, caption_y],
                  width: inner_w, height: 32)

    @pdf.fill_color INK_MUTED
    text_box @c["panel.industry.footnote"],
                  at: [x, caption_y - 34],
                  width: inner_w,
                  height: 20,
                  size: 5.4,
                  leading: 0.8,
                  overflow: :shrink_to_fit
  end

  def draw_luxury_panel(at)
    data = @f["infographic_3"]
    content_y = panel(@pdf, title: @c["panel.luxury.title"],
                            subtitle: @c["panel.luxury.subtitle"],
                            at: at, width: CELL_W, height: CELL_H)

    x = at[0] + 12
    inner_w = CELL_W - 24

    @pdf.fill_color INK_MUTED
    text_box @c["panel.luxury.chart_label"],
                  at: [x, content_y - 2],
                  width: inner_w,
                  height: 9,
                  size: 5.8,
                  style: :bold,
                  character_spacing: 0.5,
                  overflow: :shrink_to_fit

    points = data["trend"].map { |t| { cycle: t["cycle"], pct: t["pct"] } }
    trend_line(@pdf, points: points, at: [x + 10, content_y - 18],
                     width: inner_w - 28, height: 56)

    # A boxed strip under the trend carries the dollar totals the percentage line can't.
    strip_h = 28.0
    strip_y = at[1] - CELL_H + CAPTION_RESERVE + strip_h + 6
    @pdf.fill_color "FFFFFF"
    @pdf.fill_rectangle([x, strip_y], inner_w, strip_h)
    @pdf.stroke_color HAIRLINE
    @pdf.line_width HAIRLINE_WIDTH
    @pdf.stroke_rectangle([x, strip_y], inner_w, strip_h)

    @pdf.fill_color ACCENT_GOLD
    text_box money(data["total_since_2020"]),
                  at: [x + 8, strip_y - 7],
                  width: 88,
                  height: 15,
                  size: 12.5,
                  style: :bold,
                  overflow: :shrink_to_fit

    @pdf.fill_color INK_SECONDARY
    text_box @c["panel.luxury.strip"],
                  at: [x + 98, strip_y - 5],
                  width: inner_w - 106,
                  height: 24,
                  size: 6.3,
                  leading: 1,
                  overflow: :shrink_to_fit

    panel_caption(@pdf, @c["panel.luxury.caption"],
                  at: [x, at[1] - CELL_H + CAPTION_RESERVE], width: inner_w, height: 34)
  end

  def draw_geography_panel(at)
    data = @f["infographic_4"]
    content_y = panel(@pdf, title: @c["panel.geography.title"],
                            subtitle: @c["panel.geography.subtitle"],
                            at: at, width: CELL_W, height: CELL_H)

    x = at[0] + 12
    inner_w = CELL_W - 24

    # The headline here is a single proportion. A one-bar bar chart would be weaker than
    # simply showing the number, so this is a stat tile. Its label stays short because
    # the panel subtitle already says what the number measures; repeating it here only
    # pushed the bars down into the caption.
    stat_tile(@pdf,
              value: "#{data['pct_contributions_out_of_state_2026']}%",
              label: @c["panel.geography.stat_label"],
              at: [x, content_y - 2],
              width: inner_w,
              value_size: 28)

    bars_y = content_y - 54

    @pdf.fill_color INK_MUTED
    text_box @c["panel.geography.chart_label"],
                  at: [x, bars_y],
                  width: inner_w,
                  height: 9,
                  size: 5.8,
                  style: :bold,
                  character_spacing: 0.5,
                  overflow: :shrink_to_fit

    bars = data["top_states"].map { |s| { label: s["label"], value: s["value"] } }
    # row_height must clear label (7.5) + gap (3) + bar (13) = 23.5 or the next row's
    # label crowds the previous bar. 24 technically cleared it but by only 0.5pt, which
    # read as the label brushing the bar above it. 28 gives a visible ~4.5pt gap.
    horizontal_bars(@pdf, bars: bars, at: [x, bars_y - 13], width: inner_w, row_height: 28)

    # This panel's caption is a single short line, so it needs less reserve than the
    # others, which gives the three bars above it room to clear it.
    panel_caption(@pdf, @c["panel.geography.caption"],
                  at: [x, at[1] - CELL_H + 20], width: inner_w, height: 18)
  end

  # ---------------------------------------------------------------- page 2

  def page_two
    y = draw_verify_masthead

    # Section gaps are generous on purpose: this page is a set of instructions someone
    # follows with a phone in one hand, so it is set larger and airier than page 1.
    # Trimmed a few points from each when the CTA band grew to fit the voting-plan
    # paragraph; #draw_call_to_action's own collision check is what proved this was
    # still enough room, not eyeballing it.
    y = draw_steps(y - 17)
    y = draw_committee_box(y - 12)
    y = draw_glossary(y - 14)
    closing_bottom = draw_closing(y - 14)

    # The closing band is pinned above the footer rather than flowed, so it can never
    # be pushed onto the disclaimer by copy changes in the sections above it. It grows
    # upward instead, toward the searches grid drawn just above it, so that direction
    # is what draw_call_to_action checks against.
    draw_call_to_action(ceiling: closing_bottom)

    draw_footer(page_one: false)
  end

  LOGO_PATH = File.expand_path("assets/circle-c.png", __dir__)

  def draw_verify_masthead
    band_top = PAGE_HEIGHT
    band_h = 78.0

    @pdf.fill_color DEEP_NAVY
    @pdf.fill_rectangle([0, band_top], PAGE_WIDTH, band_h)

    text_w = draw_corner_graphics(band_top: band_top) - MARGIN - 16

    @pdf.fill_color TINT_LIGHT
    text_box @c["verify.eyebrow"],
                  at: [MARGIN, band_top - 16],
                  width: text_w,
                  height: 10,
                  size: 6.8,
                  style: :bold,
                  character_spacing: 0.9,
                  overflow: :shrink_to_fit

    @pdf.fill_color "FFFFFF"
    text_box @c["verify.headline"],
                  at: [MARGIN, band_top - 31],
                  width: text_w,
                  height: 22,
                  size: 17,
                  style: :bold,
                  overflow: :shrink_to_fit

    @pdf.fill_color PALE_BLUE
    text_box @c["verify.dek"],
                  at: [MARGIN, band_top - 52],
                  width: text_w,
                  height: 24,
                  size: 7.6,
                  leading: 1.3,
                  overflow: :shrink_to_fit

    band_top - band_h
  end

  CORNER_QR_SIZE = 48.0
  CORNER_LOGO_TILE_D = 46.0
  CORNER_GAP = 8.0

  # Draws the QR code and the campaign logo side by side in the top-right corner. Called
  # identically by both mastheads (only band_top differs) so the two pages mirror each
  # other by construction, not by two hand-tuned layouts that could quietly drift apart.
  # Sized to fit page 2's masthead, the shorter of the two bands (78pt) — page 1's taller
  # band (98pt) has slack to spare, but using one size on both is what makes them read as
  # a matched pair rather than two different treatments that happen to sit in the same
  # corner. Returns the cluster's left edge, in absolute page coordinates, so callers can
  # reserve text width up to it the same way a copy edit that overflows gets caught
  # instead of silently drawing under the graphics.
  def draw_corner_graphics(band_top:)
    inset = 14.0
    qr_x = PAGE_WIDTH - MARGIN - CORNER_QR_SIZE
    qr_y = band_top - inset
    qr_center_y = qr_y - (CORNER_QR_SIZE / 2)

    draw_qr(@pdf, @f["footer"]["qr_target"], at: [qr_x, qr_y], size: CORNER_QR_SIZE)

    @pdf.fill_color "FFFFFF"
    text_box @c["footer.site"],
                  at: [qr_x - 6, qr_y - CORNER_QR_SIZE - 1],
                  width: CORNER_QR_SIZE + 12,
                  height: 9,
                  size: 6,
                  align: :center,
                  overflow: :shrink_to_fit

    # A plain PNG on the navy masthead would nearly vanish: the mark's own ring color
    # (#333895) measures 1.49:1 contrast against the masthead navy (#212355), well under
    # the 3:1 floor this project holds every other mark to. White circle tile fixes that,
    # the same way the QR's own white background does, rather than recoloring campaign
    # artwork no one here is authorized to redraw.
    logo_cx = qr_x - CORNER_GAP - (CORNER_LOGO_TILE_D / 2)
    logo_d = CORNER_LOGO_TILE_D - 10

    @pdf.fill_color "FFFFFF"
    @pdf.fill_circle([logo_cx, qr_center_y], CORNER_LOGO_TILE_D / 2)
    @pdf.image LOGO_PATH,
               at: [logo_cx - (logo_d / 2), qr_center_y + (logo_d / 2)],
               width: logo_d,
               height: logo_d

    logo_cx - (CORNER_LOGO_TILE_D / 2)
  end

  def draw_steps(top_y)
    y = top_y

    @c["verify.steps"].each_with_index do |step, index|
      body_h = measured_height(step[:body], width: CONTENT_W - 44, size: 8.6, leading: 1.8)

      @pdf.fill_color SERIES_INDIGO
      @pdf.fill_circle([MARGIN + 11, y - 9], 11)
      @pdf.fill_color "FFFFFF"
      text_box (index + 1).to_s,
                    at: [MARGIN, y - 3.5],
                    width: 22,
                    height: 13,
                    size: 11,
                    style: :bold,
                    align: :center,
                    overflow: :shrink_to_fit

      @pdf.fill_color INK_PRIMARY
      text_box step[:title],
                    at: [MARGIN + 34, y],
                    width: CONTENT_W - 44,
                    height: 15,
                    size: 11,
                    style: :bold,
                    overflow: :shrink_to_fit

      @pdf.fill_color INK_SECONDARY
      text_box step[:body],
                    at: [MARGIN + 34, y - 16],
                    width: CONTENT_W - 44,
                    height: body_h + 2,
                    size: 8.6,
                    leading: 1.8,
                    overflow: :shrink_to_fit

      y -= body_h + 30
    end

    y
  end

  def draw_committee_box(top_y)
    box_h = 62.0

    @pdf.fill_color PANEL_PLANE
    @pdf.fill_rectangle([MARGIN, top_y], CONTENT_W, box_h)
    @pdf.stroke_color HAIRLINE
    @pdf.line_width HAIRLINE_WIDTH
    @pdf.stroke_rectangle([MARGIN, top_y], CONTENT_W, box_h)
    @pdf.fill_color SERIES_INDIGO
    @pdf.fill_rectangle([MARGIN, top_y], CONTENT_W, 2.5)

    @pdf.fill_color INK_PRIMARY
    text_box @c["verify.committees_heading"],
                  at: [MARGIN + 12, top_y - 11],
                  width: CONTENT_W - 24,
                  height: 10,
                  size: 7,
                  style: :bold,
                  character_spacing: 0.6,
                  overflow: :shrink_to_fit

    committees = @f["verify_page"]["committees"]
    # Column count follows the data rather than a hardcoded 3. A fixed divisor here is
    # exactly how the earlier four-committees mismatch happened: the copy and the
    # committee-ID box drifted out of sync because nothing tied them together.
    col_w = (CONTENT_W - 24) / committees.size

    committees.each_with_index do |committee, index|
      cx = MARGIN + 12 + (index * col_w)

      @pdf.fill_color ACCENT_GOLD
      text_box committee["id"],
                    at: [cx, top_y - 26],
                    width: col_w - 8,
                    height: 15,
                    size: 12,
                    style: :bold,
                    overflow: :shrink_to_fit

      @pdf.fill_color INK_SECONDARY
      text_box committee["name"],
                    at: [cx, top_y - 41],
                    width: col_w - 10,
                    height: 20,
                    size: 6.8,
                    leading: 1,
                    overflow: :shrink_to_fit
    end

    top_y - box_h
  end

  # The steps above necessarily use three pieces of campaign-finance jargon. Rather than
  # avoid the terms, since a reader will meet them the moment they land on FEC.gov, this
  # defines them plainly so the guide is actually usable.
  def draw_glossary(top_y)
    @pdf.fill_color INK_PRIMARY
    text_box @c["verify.glossary_heading"],
                  at: [MARGIN, top_y],
                  width: CONTENT_W,
                  height: 11,
                  size: 8,
                  style: :bold,
                  character_spacing: 0.8,
                  overflow: :shrink_to_fit

    @pdf.fill_color ACCENT_GOLD
    @pdf.fill_rectangle([MARGIN, top_y - 13], 34, 2)

    col_w = (CONTENT_W - 24) / 3
    body_top = top_y - 24

    @c["verify.glossary"].each_with_index do |term, index|
      cx = MARGIN + (index * (col_w + 12))

      @pdf.fill_color SERIES_INDIGO
      @pdf.fill_rectangle([cx, body_top], 18, 2)

      @pdf.fill_color INK_PRIMARY
      text_box term[:title],
                    at: [cx, body_top - 9],
                    width: col_w,
                    height: 13,
                    size: 8.6,
                    style: :bold,
                    overflow: :shrink_to_fit

      @pdf.fill_color INK_SECONDARY
      text_box term[:body],
                    at: [cx, body_top - 23],
                    width: col_w,
                    height: 44,
                    size: 7.4,
                    leading: 1.4,
                    overflow: :shrink_to_fit
    end

    body_top - 54
  end

  def draw_closing(top_y)
    @pdf.fill_color INK_PRIMARY
    text_box @c["verify.searches_heading"],
                  at: [MARGIN, top_y],
                  width: CONTENT_W,
                  height: 11,
                  size: 8,
                  style: :bold,
                  character_spacing: 0.8,
                  overflow: :shrink_to_fit

    @pdf.fill_color ACCENT_GOLD
    @pdf.fill_rectangle([MARGIN, top_y - 13], 34, 2)

    y = top_y - 24
    col_w = (CONTENT_W - 14) / 2

    @c["verify.searches"].each_with_index do |example, index|
      col = index.even? ? 0 : 1
      row = index / 2
      ex = MARGIN + (col * (col_w + 14))
      ey = y - (row * 42)

      @pdf.fill_color "FFFFFF"
      @pdf.fill_rectangle([ex, ey], col_w, 36)
      @pdf.stroke_color HAIRLINE
      @pdf.line_width HAIRLINE_WIDTH
      @pdf.stroke_rectangle([ex, ey], col_w, 36)

      @pdf.fill_color SERIES_INDIGO
      @pdf.fill_rectangle([ex, ey], 3, 36)

      @pdf.fill_color INK_PRIMARY
      text_box "Search:  “#{example[:title]}”",
                    at: [ex + 12, ey - 9],
                    width: col_w - 20,
                    height: 12,
                    size: 9,
                    style: :bold,
                    overflow: :shrink_to_fit

      @pdf.fill_color INK_SECONDARY
      text_box example[:body],
                    at: [ex + 12, ey - 21],
                    width: col_w - 20,
                    height: 12,
                    size: 7,
                    overflow: :shrink_to_fit
    end

    # 3pt of trailing air below the last card, not the 10pt this used to carry. Reclaimed
    # when the CTA band below grew to fit the voting-plan paragraph.
    y - 81
  end

  # Sized to its own content rather than a fixed 54pt, so a copy edit that adds a
  # sentence (the voting-plan paragraph did exactly this) grows the band instead of
  # clipping or shrinking the text to fit a height nobody re-checked.
  def draw_call_to_action(ceiling:)
    text_w = CONTENT_W - 36
    top_pad = 15.0
    gap = 8.0
    bottom_pad = 14.0

    headline_h = measured_height(@c["cta.headline"], width: text_w, size: 12.5)
    body_h = measured_height(@c["cta.body"], width: text_w, size: 8.2, leading: 1.5)
    band_h = top_pad + headline_h + gap + body_h + bottom_pad

    top_y = FOOTER_TOP + 18 + band_h

    # A band that grew enough to reach the content above it is a real layout bug, not
    # something #text_box's shrink_to_fit should paper over silently. Fail loudly at
    # build time instead of shipping an overlap that only a rendered proof would show.
    if top_y > ceiling
      raise "CTA band (top #{top_y.round(1)}) collides with the searches grid above it " \
            "(bottom #{ceiling.round(1)}). Trim cta.body in copy/slicksheet.md, or widen " \
            "page 2's layout."
    end

    @pdf.fill_color DEEP_NAVY
    @pdf.fill_rectangle([MARGIN, top_y], CONTENT_W, band_h)

    @pdf.fill_color "FFFFFF"
    text_box @c["cta.headline"],
                  at: [MARGIN + 18, top_y - top_pad],
                  width: text_w,
                  height: headline_h + 2,
                  size: 12.5,
                  style: :bold,
                  overflow: :shrink_to_fit

    @pdf.fill_color PALE_BLUE
    text_box @c["cta.body"],
                  at: [MARGIN + 18, top_y - top_pad - headline_h - gap],
                  width: text_w,
                  height: body_h + 2,
                  size: 8.2,
                  leading: 1.5,
                  overflow: :shrink_to_fit

    top_y - band_h
  end

  # ---------------------------------------------------------------- shared

  # Two things here are requirements rather than design choices. The disclaimer box is
  # a legal one: 8pt, boxed, on BOTH pages. The generated-on stamp is a practical one,
  # so anyone holding a printed copy can tell which run it came from and whether newer
  # filings have landed since. The QR code lives in each page's own masthead, drawn by
  # #draw_corner_graphics, not here.
  def draw_footer(page_one:)
    @pdf.stroke_color HAIRLINE
    @pdf.line_width HAIRLINE_WIDTH
    @pdf.stroke_line([MARGIN, FOOTER_TOP], [PAGE_WIDTH - MARGIN, FOOTER_TOP])

    box_w = 214.0
    box_h = 22.0
    box_y = FOOTER_TOP - 12

    @pdf.stroke_color INK_PRIMARY
    @pdf.line_width 1
    @pdf.stroke_rectangle([MARGIN, box_y], box_w, box_h)

    @pdf.fill_color INK_PRIMARY
    text_box @c["footer.disclaimer"],
                  at: [MARGIN, box_y - 6.5],
                  width: box_w,
                  height: 11,
                  size: 8,
                  align: :center,
                  overflow: :shrink_to_fit

    @pdf.fill_color INK_MUTED
    text_box "#{@c['footer.source_note']}  #{generated_stamp}.",
                  at: [MARGIN + box_w + 16, box_y - 2],
                  width: CONTENT_W - box_w - 16,
                  height: 22,
                  size: 6.2,
                  leading: 1,
                  overflow: :shrink_to_fit

    label = page_one ? @c["footer.turn_over"] : @c["footer.site"]
    @pdf.fill_color INK_SECONDARY
    text_box label,
                  at: [MARGIN, box_y - box_h - 10],
                  width: CONTENT_W,
                  height: 10,
                  size: 7,
                  style: :bold,
                  align: :right,
                  overflow: :shrink_to_fit
  end
end

options = {
  out: File.expand_path("output/claire-reynolds-slicksheet.pdf", __dir__),
  copy: File.expand_path("copy/slicksheet.md", __dir__)
}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby pdf/build-slicksheet.rb [options]"
  opts.on("--out PATH", "Write the PDF to PATH") { |v| options[:out] = v }
  opts.on("--copy PATH", "Copy deck markdown to render (default: copy/slicksheet.md)") do |v|
    options[:copy] = v
  end
  # Lets a rebuild reproduce an earlier run's stamp byte-for-byte, e.g. when
  # regenerating a sheet that already went to a printer, or when the source report's
  # own mtime has drifted (a reformat, a git checkout) without its content changing.
  opts.on("--generated-at DATE", "Override the data-as-of stamp (YYYY-MM-DD, default: source report's file mtime)") do |v|
    options[:generated_at] = Date.parse(v).to_time
  end
  opts.on("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

# Default: pin the stamp to the source report's own file mtime, not to whenever this
# script happens to run — see the comment on SlickSheet::SOURCE_REPORT and #generated_stamp
# for why. Only File.mtime (not the file's content) is consulted; if that report gets
# touched without its content actually changing (a whitespace fix, a git checkout that
# resets mtimes), --generated-at above is the escape hatch.
options[:generated_at] ||= begin
  abort "build-slicksheet.rb: source report not found: #{SlickSheet::SOURCE_REPORT}" unless File.exist?(SlickSheet::SOURCE_REPORT)
  File.mtime(SlickSheet::SOURCE_REPORT)
end

figures = YAML.load_file(File.expand_path("data/figures.yml", __dir__))
copy = CopyDeck.load(options[:copy])
path = SlickSheet.new(figures, copy, options[:out], generated_at: options[:generated_at]).build
puts "Wrote #{path}"
