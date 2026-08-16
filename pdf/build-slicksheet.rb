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
# Three elements are requirements, not design choices: the "Paid for by" disclaimer box
# and the generated-on timestamp both appear on BOTH pages, and the claire11.org QR
# code appears exactly ONCE (page 1 only).

require "prawn"
require "yaml"
require "optparse"
require "date"

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

  def initialize(figures, copy, out_path, generated_at: Time.now)
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
        CreationDate: @generated_at
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

  # The stamp that tells you which print run you are holding.
  def generated_stamp = "Generated #{@generated_at.strftime('%B %-d, %Y')}"

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

    # QR sits in the masthead's right edge on a white tile — the tile doubles as the
    # scanner quiet zone, so it's functional, not just a design flourish.
    qr_size = 62.0
    qr_x = PAGE_WIDTH - MARGIN - qr_size
    qr_y = band_top - 15
    draw_qr(@pdf, @f["footer"]["qr_target"], at: [qr_x, qr_y], size: qr_size)

    @pdf.fill_color "FFFFFF"
    text_box @c["footer.site"],
                  at: [qr_x - 6, qr_y - qr_size - 1],
                  width: qr_size + 12,
                  height: 9,
                  size: 6,
                  align: :center,
                  overflow: :shrink_to_fit

    text_w = qr_x - MARGIN - 16

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
              value: "#{data['pct_contributions_out_of_state']}%",
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
    # row_height must stay >= label (7.5) + gap (3) + bar (13); at 22 the next row's
    # label crept onto the previous bar.
    horizontal_bars(@pdf, bars: bars, at: [x, bars_y - 13], width: inner_w, row_height: 24)

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
    y = draw_steps(y - 20)
    y = draw_committee_box(y - 14)
    y = draw_glossary(y - 16)
    draw_closing(y - 16)

    # The closing band is pinned above the footer rather than flowed, so it can never
    # be pushed onto the disclaimer by copy changes in the sections above it.
    draw_call_to_action

    draw_footer(page_one: false)
  end

  def draw_verify_masthead
    band_top = PAGE_HEIGHT
    band_h = 78.0

    @pdf.fill_color DEEP_NAVY
    @pdf.fill_rectangle([0, band_top], PAGE_WIDTH, band_h)

    @pdf.fill_color TINT_LIGHT
    text_box @c["verify.eyebrow"],
                  at: [MARGIN, band_top - 16],
                  width: CONTENT_W,
                  height: 10,
                  size: 6.8,
                  style: :bold,
                  character_spacing: 0.9,
                  overflow: :shrink_to_fit

    @pdf.fill_color "FFFFFF"
    text_box @c["verify.headline"],
                  at: [MARGIN, band_top - 31],
                  width: CONTENT_W,
                  height: 22,
                  size: 17,
                  style: :bold,
                  overflow: :shrink_to_fit

    @pdf.fill_color PALE_BLUE
    text_box @c["verify.dek"],
                  at: [MARGIN, band_top - 52],
                  width: CONTENT_W - 90,
                  height: 24,
                  size: 7.6,
                  leading: 1.3,
                  overflow: :shrink_to_fit

    band_top - band_h
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

    col_w = (CONTENT_W - 24) / 3

    @f["verify_page"]["committees"].each_with_index do |committee, index|
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

    y - 88
  end

  def draw_call_to_action
    band_h = 54.0
    top_y = FOOTER_TOP + 18 + band_h

    @pdf.fill_color DEEP_NAVY
    @pdf.fill_rectangle([MARGIN, top_y], CONTENT_W, band_h)

    @pdf.fill_color "FFFFFF"
    text_box @c["cta.headline"],
                  at: [MARGIN + 18, top_y - 15],
                  width: CONTENT_W - 36,
                  height: 16,
                  size: 12.5,
                  style: :bold,
                  overflow: :shrink_to_fit

    @pdf.fill_color PALE_BLUE
    text_box @c["cta.body"],
                  at: [MARGIN + 18, top_y - 33],
                  width: CONTENT_W - 36,
                  height: 16,
                  size: 8.2,
                  overflow: :shrink_to_fit

    top_y - band_h
  end

  # ---------------------------------------------------------------- shared

  # Two things here are requirements rather than design choices. The disclaimer box is
  # a legal one: 8pt, boxed, on BOTH pages. The generated-on stamp is a practical one,
  # so anyone holding a printed copy can tell which run it came from and whether newer
  # filings have landed since. The QR code is page 1 only and lives in that masthead.
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
  copy: File.expand_path("copy/slicksheet.md", __dir__),
  generated_at: Time.now
}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby pdf/build-slicksheet.rb [options]"
  opts.on("--out PATH", "Write the PDF to PATH") { |v| options[:out] = v }
  opts.on("--copy PATH", "Copy deck markdown to render (default: copy/slicksheet.md)") do |v|
    options[:copy] = v
  end
  # Lets a rebuild reproduce an earlier run's stamp byte-for-byte, e.g. when
  # regenerating a sheet that already went to a printer.
  opts.on("--generated-at DATE", "Override the generated-on stamp (YYYY-MM-DD)") do |v|
    options[:generated_at] = Date.parse(v).to_time
  end
  opts.on("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

figures = YAML.load_file(File.expand_path("data/figures.yml", __dir__))
copy = CopyDeck.load(options[:copy])
path = SlickSheet.new(figures, copy, options[:out], generated_at: options[:generated_at]).build
puts "Wrote #{path}"
