# frozen_string_literal: true

# Builds minimal, valid single-page PDFs for HouseEthicsScanner specs, so tests don't
# need to check real House Ethics filings (large, and drawn from real members' financial
# disclosures) into the repo as binary fixtures. Just enough PDF structure (catalog, one
# page, one Helvetica content stream, a correct xref table) for pdf-reader to extract the
# text back out losslessly — verified against pdf-reader directly when this helper was
# written.
module PdfFixtures
  # Writes a one-page PDF whose text content is `lines` (array of strings, one per text
  # line) to a fresh temp file and returns its path.
  def build_pdf(lines)
    content = lines.each_with_index.map { |line, i|
      y = 700 - (i * 20)
      "BT /F1 12 Tf 72 #{y} Td (#{escape_pdf_text(line)}) Tj ET"
    }.join(" ")

    objects = [
      "<</Type/Catalog/Pages 2 0 R>>",
      "<</Type/Pages/Kids[3 0 R]/Count 1>>",
      "<</Type/Page/Parent 2 0 R/Resources<</Font<</F1 4 0 R>>>>/MediaBox[0 0 612 792]/Contents 5 0 R>>",
      "<</Type/Font/Subtype/Type1/BaseFont/Helvetica>>",
      "<</Length #{content.bytesize}>>\nstream\n#{content}\nendstream"
    ]

    pdf = +"%PDF-1.4\n"
    offsets = [0]
    objects.each_with_index do |body, i|
      offsets << pdf.bytesize
      pdf << "#{i + 1} 0 obj\n#{body}\nendobj\n"
    end
    xref_offset = pdf.bytesize
    pdf << "xref\n0 #{objects.size + 1}\n0000000000 65535 f \n"
    offsets[1..].each { |o| pdf << format("%010d 00000 n \n", o) }
    pdf << "trailer\n<</Size #{objects.size + 1}/Root 1 0 R>>\nstartxref\n#{xref_offset}\n%%EOF"

    path = File.join(Dir.mktmpdir("pdf-fixture"), "filing.pdf")
    File.binwrite(path, pdf)
    path
  end

  private

  def escape_pdf_text(str)
    str.gsub("\\", "\\\\\\\\").gsub("(", "\\(").gsub(")", "\\)")
  end
end
