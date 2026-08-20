# frozen_string_literal: true

# Hand-drawn chart primitives on top of Prawn's rectangle/line/text calls.
#
# Prawn has no charting support, and every Ruby charting gem that does either needs
# Cairo/ImageMagick native extensions or renders to a raster image that prints soft.
# The four forms this sheet needs (horizontal bars, a trend line, a hero stat, a
# two-bar contrast) are a few dozen lines of vector drawing each, so they live here
# instead — no native extensions, crisp at any print resolution.
#
# PALETTE & MARK SPECS
#
# The palette is the Claire Reynolds campaign's own brand palette, taken from the
# campaign site's stylesheet and confirmed by sampling the published logo artwork
# (about two-thirds of all colored logo pixels fall in the brand indigo family, with
# gold as the single accent).
#
# The two brand colors as-published are a deep indigo (#333794) and a bright gold
# (#faa533). Neither is usable as a *data mark* unmodified: run through a
# colorblind-safety validator against white paper, the indigo comes out too dark and
# the gold too light for the mark lightness band, and the bright gold lands at only
# 2:1 contrast on white — it would disappear in print. Both hues therefore use the
# mid-steps the campaign's own stylesheet already ships (#6064c8 and #d87e05), which
# together clear every gate: CVD ΔE 28.3 and normal-vision ΔE 31.7 (floors are 8 and
# 15), and both above 3:1 contrast on white.
#
# The unmodified brand colors are still used where they belong — as chrome. DEEP_NAVY
# (#212355, the site's most-used color) is the masthead; BRAND_INDIGO (#333794) is the
# rule at the top of each panel. Chrome isn't held to the data-mark band because it
# never encodes a value.
#
# Two rules that shaped this file, worth keeping if you edit it:
#
#   1. ONE COLOR PER SERIES, not a value-ramp across nominal categories. Every bar in
#      a single chart here gets SERIES_INDIGO, even though a darker-where-bigger ramp
#      is tempting. The categories on this sheet (spending destinations, industries,
#      states) have no inherent order, so a ramp would double-encode bar length as
#      hue — burning the one free visual channel to restate what length already says.
#      ACCENT_GOLD is used only to highlight the single mark a chart is arguing about,
#      never as "series 2."
#
#   2. TEXT NEVER WEARS THE DATA COLOR. Bars are indigo/gold; the labels and values
#      beside them are ink (INK_PRIMARY / INK_SECONDARY / INK_MUTED). A colored mark
#      next to ink text carries identity fine, and light data colors are illegible
#      as small print text.
module ChartHelpers
  # --- Palette (Claire Reynolds campaign brand) ----------------------------
  SERIES_INDIGO = "6064c8" # brand indigo, mid-step — the default data mark
  ACCENT_GOLD   = "d87e05" # brand gold, darkened step — highlight marks only

  DEEP_NAVY    = "212355" # brand primary dark — masthead/chrome, never a data mark
  BRAND_INDIGO = "333794" # brand indigo as published — panel rules, chrome only
  PALE_BLUE    = "e8f0ff" # brand pale tint — callout backgrounds
  TINT_LIGHT   = "a9acdc" # brand light indigo — eyebrow text on navy

  INK_PRIMARY   = "16162e"
  INK_SECONDARY = "4a4a63"
  INK_MUTED     = "8a8a9c"

  SURFACE     = "ffffff"
  PANEL_PLANE = "f5f7fe"
  HAIRLINE    = "dfe3f2"
  BASELINE    = "c3c7dd"

  # --- Mark specs ----------------------------------------------------------
  BAR_THICKNESS  = 13   # capped, so the band's leftover stays as air
  BAR_RADIUS     = 3    # rounded data-end, squared at the baseline
  LINE_WIDTH     = 2
  MARKER_RADIUS  = 3.5
  SURFACE_GAP    = 2    # white gap separating adjacent marks — never a border stroke
  HAIRLINE_WIDTH = 0.5

  # Formats a dollar amount the way a reader scans it on paper: whole dollars,
  # thousands-separated. Cents are noise at this size and in this context.
  def money(amount)
    "$#{amount.round.to_s.reverse.scan(/\d{1,3}/).join(',').reverse}"
  end

  # Compact form for axis-free bar tips where the full number would crowd the mark.
  def money_compact(amount)
    if amount >= 1_000_000
      format("$%.1fM", amount / 1_000_000.0)
    elsif amount >= 1_000
      format("$%.0fK", amount / 1_000.0)
    else
      money(amount)
    end
  end

  # Draws one horizontal bar growing rightward from x0, with a rounded data-end and
  # a square baseline end (per the mark spec — the baseline is where the bar is
  # anchored, so it stays flat).
  def draw_bar(pdf, x0, y_top, width, thickness, color)
    return if width <= 0

    pdf.fill_color color
    if width > BAR_RADIUS * 2
      pdf.fill_rounded_rectangle([x0, y_top], width, thickness, BAR_RADIUS)
      # Square off the baseline end by overdrawing its rounded corners.
      pdf.fill_rectangle([x0, y_top], BAR_RADIUS, thickness)
    else
      pdf.fill_rectangle([x0, y_top], width, thickness)
    end
  end

  # Horizontal bar chart: category label above each bar, value at the tip.
  #
  # No y-axis and no gridlines by design — with 2-4 bars and a direct label on every
  # tip, an axis would be chrome carrying no information the labels don't already.
  # (Labeling every bar is right *here* because the chart is tiny and sparse; on a
  # dense chart it becomes noise and the axis should carry the values instead.)
  #
  # +bars+ is an array of { label:, value:, color: (optional), note: (optional) }.
  def horizontal_bars(pdf, bars:, at:, width:, row_height: 30, label_size: 7.5, value_size: 8.5, max_value: nil)
    x, y = at
    scale_max = max_value || bars.map { |b| b[:value] }.max.to_f
    return if scale_max <= 0

    # Reserve room at the right for the tip label so a long bar never collides with it.
    plot_width = width - 62

    bars.each_with_index do |bar, index|
      row_y = y - (index * row_height)
      color = bar[:color] || SERIES_INDIGO

      pdf.fill_color INK_SECONDARY
      pdf.text_box bar[:label],
                   at: [x, row_y],
                   width: width,
                   height: label_size + 3,
                   size: label_size,
                   style: :bold,
                   overflow: :shrink_to_fit

      bar_top = row_y - label_size - 3
      bar_width = (bar[:value] / scale_max) * plot_width
      draw_bar(pdf, x, bar_top, bar_width, BAR_THICKNESS, color)

      # Value rides just past the bar tip, in ink — never inside the bar, where a
      # short bar would clip it.
      pdf.fill_color INK_PRIMARY
      pdf.text_box money(bar[:value]),
                   at: [x + bar_width + 5, bar_top - 2.5],
                   width: 70,
                   height: value_size + 2,
                   size: value_size,
                   style: :bold,
                   overflow: :shrink_to_fit

      next unless bar[:note]

      # INK_SECONDARY: this note sits on a panel's tinted background, not white — see the
      # rationale on the #panel subtitle above (same background, same legibility floor).
      pdf.fill_color INK_SECONDARY
      pdf.text_box bar[:note],
                   at: [x, bar_top - BAR_THICKNESS - 1.5],
                   width: width,
                   height: 9,
                   size: 6.5,
                   overflow: :shrink_to_fit
    end
  end

  # Trend line over evenly spaced periods, with a filled marker on every point and
  # the first and last points directly labeled.
  #
  # Only the endpoints get labels: they carry the whole argument ("0.30% then, 7.22%
  # now"), and labeling all four would flood a chart this small.
  def trend_line(pdf, points:, at:, width:, height:, color: SERIES_INDIGO, label_size: 7)
    x, y = at
    values = points.map { |p| p[:pct] }
    max = values.max.to_f
    # Headroom above the peak so the top marker and its label don't touch the panel edge.
    scale_max = max * 1.25

    step_x = width / (points.size - 1).to_f
    coords = points.each_with_index.map do |point, index|
      [x + (index * step_x), y - height + ((point[:pct] / scale_max) * height)]
    end

    # Baseline: solid hairline, recessive — never dashed.
    pdf.stroke_color BASELINE
    pdf.line_width HAIRLINE_WIDTH
    pdf.stroke_line([x, y - height], [x + width, y - height])

    pdf.stroke_color color
    pdf.line_width LINE_WIDTH
    pdf.cap_style :round
    pdf.join_style :round
    coords.each_cons(2) { |a, b| pdf.stroke_line(a, b) }
    pdf.line_width HAIRLINE_WIDTH

    coords.each_with_index do |(cx, cy), index|
      # 2pt surface ring keeps a marker legible where it sits on the line.
      pdf.fill_color SURFACE
      pdf.fill_circle([cx, cy], MARKER_RADIUS + 1)
      pdf.fill_color color
      pdf.fill_circle([cx, cy], MARKER_RADIUS)

      # INK_SECONDARY, not INK_MUTED: these axis labels sit on the panel's tinted
      # background, same legibility floor as the subtitle above.
      pdf.fill_color INK_SECONDARY
      pdf.text_box points[index][:cycle].to_s,
                   at: [cx - 16, y - height - 3],
                   width: 32,
                   height: label_size + 2,
                   size: label_size,
                   align: :center,
                   overflow: :shrink_to_fit

      next unless index.zero? || index == points.size - 1

      pdf.fill_color INK_PRIMARY
      pdf.text_box format("%.2f%%", points[index][:pct]),
                   at: [cx - 20, cy + MARKER_RADIUS + 12],
                   width: 40,
                   height: label_size + 4,
                   size: label_size + 1.5,
                   style: :bold,
                   align: :center,
                   overflow: :shrink_to_fit
    end
  end

  # The hero figure — one big number that IS the chart. Used where a bar chart of a
  # single value would be a one-bar bar chart (an anti-pattern); the number carries
  # it better. Proportional figures, same sans as everything else.
  def stat_tile(pdf, value:, label:, at:, width:, value_size: 40, color: ACCENT_GOLD)
    x, y = at

    pdf.fill_color color
    pdf.text_box value,
                 at: [x, y],
                 width: width,
                 height: value_size + 6,
                 size: value_size,
                 style: :bold,
                 overflow: :shrink_to_fit

    pdf.fill_color INK_SECONDARY
    pdf.text_box label,
                 at: [x, y - value_size - 3],
                 width: width,
                 height: 26,
                 size: 7.5,
                 leading: 1.5,
                 overflow: :shrink_to_fit
  end

  # A titled panel — the card each infographic sits in. Returns the y coordinate
  # where the panel's own content may start, so callers never guess at the offset.
  def panel(pdf, title:, subtitle:, at:, width:, height:)
    x, y = at

    pdf.fill_color PANEL_PLANE
    pdf.fill_rectangle([x, y], width, height)
    pdf.stroke_color HAIRLINE
    pdf.line_width HAIRLINE_WIDTH
    pdf.stroke_rectangle([x, y], width, height)

    # Accent rule at the panel's top edge — chrome that makes the grid read as four
    # distinct cards at a glance without adding a heavy border. Uses the brand indigo
    # as published, not the lightened data-mark step, so it never reads as a bar.
    pdf.fill_color BRAND_INDIGO
    pdf.fill_rectangle([x, y], width, 2.5)

    inner_x = x + 12
    inner_width = width - 24

    pdf.fill_color INK_PRIMARY
    pdf.text_box title,
                 at: [inner_x, y - 12],
                 width: inner_width,
                 height: 14,
                 size: 10.5,
                 style: :bold,
                 overflow: :shrink_to_fit

    # INK_SECONDARY, not INK_MUTED: this subtitle is a full explanatory sentence a reader
    # is meant to read, sitting on PANEL_PLANE's light indigo tint. INK_MUTED (#8a8a9c) at
    # 6.8pt on that background prints too faint to read comfortably; INK_SECONDARY
    # (#4a4a63) holds the same visual hierarchy below the bold title without disappearing
    # on paper. INK_MUTED stays correct for this file's other uses — axis labels and
    # footnotes, which are meant to recede rather than be read line by line.
    pdf.fill_color INK_SECONDARY
    subtitle_height = pdf.height_of(subtitle, width: inner_width, size: 6.8, leading: 1)
    pdf.text_box subtitle,
                 at: [inner_x, y - 26],
                 width: inner_width,
                 height: subtitle_height + 2,
                 size: 6.8,
                 leading: 1,
                 overflow: :shrink_to_fit

    y - 28 - subtitle_height - 8
  end

  # The caption pinned to a panel's bottom edge — the sentence that says what the
  # chart means, so the reader never has to infer the argument from the marks alone.
  def panel_caption(pdf, text, at:, width:, height: 34)
    x, y = at
    pdf.fill_color INK_SECONDARY
    pdf.text_box text,
                 at: [x, y],
                 width: width,
                 height: height,
                 size: 7,
                 leading: 1.4,
                 overflow: :shrink_to_fit
  end
end
