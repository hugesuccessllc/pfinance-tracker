# frozen_string_literal: true

# Shared FEC Schedule A `line_number_label` constants, extracted for the same reason
# lib/fec_committees.rb was: donor-keyword-scan.rb and donor-trace.rb both need DONOR_LABELS,
# and both are top-level scripts that get `require`-d into the SAME process under RSpec (and,
# eventually, one web app). Two identical top-level `DONOR_LABELS = [...]` definitions produce
# a "warning: already initialized constant" and, worse, leave a live footgun: whichever file
# loads second silently wins, so editing one copy would stop taking effect with no error.
#
# analyze-candidate.rb has its own DONOR_LABELS, but scoped INSIDE the FecAnalyzer class, so
# it never collides with this top-level one and deliberately isn't shared from here — see the
# same note in lib/fec_committees.rb.

# Rows where an outside party actually gave a committee money. Deliberately excludes
# "Transfers from authorized committees" — a JFC redistributing pooled money to a participant
# is not a donor relationship, and those rows also carry the memo-itemized earmark attributions
# that would double-count against the JFC's own direct receipts (analyze-candidate.rb gotcha 7).
DONOR_LABELS = [
  "Contributions From Individuals/Persons Other Than Political Committees",
  "Contributions From Other Political Committees"
].freeze

# The line a participating committee files a JFC transfer under. Stored DOWNCASED and always
# compared downcased: real Pfluger data spells this "Transfers from authorized committees" in
# C00719294 and "Transfers from Authorized Committees" in C00749481 — the same FEC line,
# capitalized differently by different filing software. An exact-string match against one
# spelling silently finds zero rows in the other committee, which reads as a clean "nothing
# found" result rather than a bug.
TRANSFER_LABELS = ["transfers from authorized committees"].freeze
