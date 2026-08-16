# frozen_string_literal: true

# Parses copy/slicksheet.md into the strings the sheet draws.
#
# WHY THIS EXISTS: the sheet's wording used to be split between string literals in
# build-slicksheet.rb and prose fields in data/figures.yml, which meant a copy edit
# required touching layout code or the data file. Now all prose lives in one markdown
# file a non-programmer can edit, data/figures.yml holds only numbers and their
# citations, and the build script holds only layout.
#
# THE FORMAT (see the header of copy/slicksheet.md for the operator-facing version):
#
#   ## slot.name          starts a slot; the key is the heading text, verbatim
#   ### Entry title       under a slot, makes it a list of {title:, body:} entries
#   - list item           under a slot, makes it a list of strings
#   anything else         plain text; blank-line-separated paragraphs are joined
#
# Everything above the first `##` heading is operator documentation and is ignored.
#
# Markdown conventions handled: `**bold**` becomes Prawn's `<b>` inline-format tag, and
# straight quotes become typographic quotes so the operator never has to type them.
class CopyDeck
  # The rule this class exists to enforce mechanically rather than by good intentions:
  # an em-dash reads as lazy AI authorship to a lot of people, so none may reach the
  # printed page. Checked at load, with the offending slot named, because a build that
  # fails loudly at the source beats spotting it on a printed proof.
  EM_DASH = "—"

  class EmDashError < StandardError; end

  def self.load(path)
    new(File.read(path), path)
  end

  def initialize(source, path = "(string)")
    @path = path
    @slots = parse(source)
    assert_no_em_dashes!
  end

  # Fetches a slot, raising on a missing key rather than silently drawing nothing —
  # a typo'd slot name should stop the build, not ship a blank space on a mailer.
  def [](key)
    @slots.fetch(key) do
      raise KeyError, "copy slot #{key.inspect} not found in #{@path}. " \
                      "Available: #{@slots.keys.sort.join(', ')}"
    end
  end

  def key?(key) = @slots.key?(key)
  def keys = @slots.keys

  private

  def parse(source)
    slots = {}
    current_key = nil
    buffer = []

    source.each_line do |line|
      if (m = line.match(/\A##\s+(?!#)(.+?)\s*\z/))
        slots[current_key] = finalize(buffer) if current_key
        current_key = m[1]
        buffer = []
      elsif current_key
        buffer << line
      end
    end
    slots[current_key] = finalize(buffer) if current_key
    slots
  end

  # Decides what shape a slot's body takes from what the operator actually wrote, so
  # they never have to declare a type: `###` headings mean titled entries, `-` bullets
  # mean a list of lines, anything else is a single block of text.
  def finalize(lines)
    text = lines.join
    return titled_entries(text) if text.match?(/^###\s+/)
    return bullets(text) if text.match?(/^-\s+/)

    paragraph(text)
  end

  def titled_entries(text)
    entries = []
    text.split(/^###\s+/).each_with_index do |chunk, index|
      next if index.zero? && !text.start_with?("### ")
      next if chunk.strip.empty?

      title, *body = chunk.lines
      entries << { title: inline(title.to_s.strip), body: paragraph(body.join) }
    end
    entries
  end

  def bullets(text)
    text.scan(/^-\s+(.*(?:\n(?!\s*-\s|\s*\n).*)*)/).map { |m| paragraph(m.first) }
  end

  # Joins wrapped lines back into flowing prose. The markdown file wraps at ~90 columns
  # for readable diffs; those newlines are an artifact of the file, not of the copy.
  def paragraph(text)
    inline(text.strip.split(/\n{2,}/).map { |para| para.gsub(/\s*\n\s*/, " ").strip }.join("\n\n"))
  end

  def inline(text)
    text
      .gsub(/\*\*(.+?)\*\*/, '<b>\1</b>')
      .gsub(/(^|[\s(\[])"/) { "#{::Regexp.last_match(1)}“" }
      .gsub('"', "”")
      .gsub(/(^|[\s(\[])'/) { "#{::Regexp.last_match(1)}‘" }
      .gsub("'", "’")
  end

  def assert_no_em_dashes!
    offenders = @slots.select { |_key, value| contains_em_dash?(value) }.keys
    return if offenders.empty?

    raise EmDashError,
          "em-dash found in #{@path}, in slot(s): #{offenders.join(', ')}. " \
          "Rewrite as complete sentences instead; see the rules at the top of that file."
  end

  def contains_em_dash?(value)
    case value
    when String then value.include?(EM_DASH)
    when Array then value.any? { |v| contains_em_dash?(v) }
    when Hash then value.values.any? { |v| contains_em_dash?(v) }
    else false
    end
  end
end
