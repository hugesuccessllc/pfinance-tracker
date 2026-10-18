# frozen_string_literal: true

# Shared by vendor-keyword-scan.rb, donor-keyword-scan.rb and donor-trace.rb (all
# `require_relative` this instead of each defining their own copy of `committees`) —
# analyze-candidate.rb has the same concept but as a method scoped inside FecAnalyzer, so it
# never collides with this top-level one and doesn't need to share this file.
#
# Lists a candidate's committee subdirectories under a --fec-dir: one per committee ID
# (e.g. "C00719294"), each expected to hold that committee's schedule_a-*.csv /
# schedule_b-*.csv / efile-*.csv exports. Sorted for stable, reproducible output ordering.
#
# A directory holding a `CONNECTED` marker file is skipped unless include_connected is true,
# matching analyze-candidate.rb's gotcha 9 and the root README's "connected committees are
# opt-in" rule. Before this, the scan tools silently folded a CONNECTED outside JFC into their
# results. On August Pfluger's data that was American Battleground Fund (C00857649), which
# added $1.22M of other candidates' donors to an oil-and-gas keyword scan of his committees.
CONNECTED_MARKER_FILE = "CONNECTED"

def committees(fec_dir, include_connected: false)
  Dir.children(fec_dir)
     .select { |d| d =~ /\AC\d{6,}\z/ && File.directory?(File.join(fec_dir, d)) }
     .reject { |d| !include_connected && File.exist?(File.join(fec_dir, d, CONNECTED_MARKER_FILE)) }
     .sort
end
