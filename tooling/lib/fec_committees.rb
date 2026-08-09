# frozen_string_literal: true

# Shared by vendor-keyword-scan.rb and donor-keyword-scan.rb (both `require_relative` this
# instead of each defining their own copy of `committees`) — analyze-candidate.rb has the
# same concept but as a method scoped inside FecAnalyzer, so it never collides with this
# top-level one and doesn't need to share this file.
#
# Lists a candidate's committee subdirectories under a --fec-dir: one per committee ID
# (e.g. "C00719294"), each expected to hold that committee's schedule_a-*.csv /
# schedule_b-*.csv / efile-*.csv exports. Sorted for stable, reproducible output ordering.
def committees(fec_dir)
  Dir.children(fec_dir)
     .select { |d| d =~ /\AC\d{6,}\z/ && File.directory?(File.join(fec_dir, d)) }
     .sort
end
