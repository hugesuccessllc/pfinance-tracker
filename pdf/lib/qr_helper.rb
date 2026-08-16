# frozen_string_literal: true

require "rqrcode"

# Draws a QR code directly as Prawn vector squares.
#
# Deliberately no PNG/image pipeline: rqrcode can render PNGs, but that pulls in
# chunky_png rasterization and embeds a bitmap that prints soft at small sizes. A QR
# code is just a grid of filled squares, so drawing it as vector rectangles keeps it
# crisp at any print resolution and keeps this directory's dependencies minimal.
module QrHelper
  # A QR code needs a "quiet zone" — blank margin on all four sides — or scanners
  # struggle to find its edges. The spec calls for 4 modules; we draw it in the
  # surface color as part of the code's own footprint.
  QUIET_ZONE_MODULES = 4

  # Draws the QR for +url+ with its top-left corner at +at+ ([x, y] in Prawn's
  # bottom-left origin), fitting the whole thing (quiet zone included) into a
  # +size+ x +size+ point square.
  def draw_qr(pdf, url, at:, size:, color: "000000", background: "FFFFFF")
    modules = RQRCode::QRCode.new(url, level: :m).qrcode.modules
    grid = modules.size + (QUIET_ZONE_MODULES * 2)
    module_size = size.to_f / grid

    x, y = at

    pdf.fill_color background
    pdf.fill_rectangle([x, y], size, size)

    pdf.fill_color color
    modules.each_with_index do |row, row_index|
      row.each_with_index do |dark, col_index|
        next unless dark

        # +0.5 module overdraw on width/height closes the hairline seams that
        # otherwise appear between adjacent squares in some PDF viewers, without
        # visibly thickening the module (each square still starts on its own grid cell).
        pdf.fill_rectangle(
          [
            x + ((col_index + QUIET_ZONE_MODULES) * module_size),
            y - ((row_index + QUIET_ZONE_MODULES) * module_size)
          ],
          module_size + 0.5,
          module_size + 0.5
        )
      end
    end
  end
end
