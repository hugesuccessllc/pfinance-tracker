# frozen_string_literal: true

# Shared RSpec setup for every spec in tooling/spec/.
#
# Run the whole suite with `bundle exec rspec` from inside tooling/, or from the repo
# root with `BUNDLE_GEMFILE=tooling/Gemfile bundle exec rspec tooling/spec` — same rule
# as running the tools themselves (see tooling/README.md's "Running the tests" section
# and tooling/lib/bootstrap.rb for why `bundle exec` alone from the repo root doesn't
# resolve gems correctly).
#
# Each tool file (analyze-candidate.rb, donor-keyword-scan.rb, vendor-keyword-scan.rb,
# fec-api-client.rb) is a plain script guarded with `if $PROGRAM_NAME == __FILE__` around
# its CLI entry point, so `require_relative`-ing it from a spec loads its classes/structs/
# methods with no side effects (no ARGV parsing, no stdout, no filesystem writes) — see
# each tool's own header comment for the "TESTING" note.
#
# Every spec file must `require_relative "spec_helper"` (or "../spec_helper" from a
# subdirectory like spec/analyze_candidate/) itself, in addition to whatever it requires
# from tooling/ — don't rely solely on tooling/.rspec's `--require spec_helper` line.
# RSpec resolves that line relative to the process's CURRENT WORKING DIRECTORY (it adds
# `./lib` and `./spec` to $LOAD_PATH before requiring), not relative to the .rspec file's
# own location — so it silently does nothing when the suite is invoked from the repo root
# instead of from inside tooling/ (no LoadError; spec_helper just never loads, and every
# fixture-helper call fails with a confusing NameError instead). `require_relative` doesn't
# have that problem: it always resolves relative to the requiring file itself, and is a
# harmless no-op if tooling/.rspec's own `--require` already loaded the same file first.

require_relative "../lib/bootstrap"

require "rspec"
require "webmock/rspec"
require "tmpdir"
require "fileutils"
require "stringio"

# Every spec works against throwaway fixture directories/files, never against real
# candidate data under tx-*/ — this blocks accidental real HTTP calls too (relevant to
# fec-api-client.rb's specs, which stub Net::HTTP instead of hitting api.open.fec.gov).
WebMock.disable_net_connect!(allow_localhost: true)

Dir[File.join(__dir__, "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  config.include FixtureHelpers
  config.include PdfFixtures
  config.include OutputCapture
end
