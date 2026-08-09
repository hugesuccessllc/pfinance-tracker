# frozen_string_literal: true

# Shared Bundler bootstrap for every script in tooling/.
#
# Every tool in this directory starts with `require_relative "lib/bootstrap"` as its
# first line (before any other require). That pins gem resolution to tooling/Gemfile —
# not the empty repo-root Gemfile — so plain `ruby tooling/<script>.rb` resolves this
# directory's gems (pdf-reader, csv, bigdecimal, rspec) correctly no matter what your
# working directory is, with no `bundle exec` and no manual `BUNDLE_GEMFILE=` prefix.
# `require_relative` itself needs no gems, so it's safe to use before Bundler is set up.
#
# Do NOT invoke a tool via `bundle exec ruby tooling/<script>.rb` from the repo root:
# `bundle exec` sets BUNDLE_GEMFILE to the repo-root Gemfile *before* this file ever runs,
# and the `||=` below can't override an already-set env var. That makes Bundler resolve
# against the wrong Gemfile and fail with e.g. "cannot load such file -- pdf-reader" even
# though everything is installed correctly. Plain `ruby` (no `bundle exec`) is the correct
# invocation — see tooling/README.md. If you ever do need `bundle exec` for some other
# reason, prefix it explicitly instead: `BUNDLE_GEMFILE=tooling/Gemfile bundle exec ruby
# tooling/<script>.rb ...`.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
require "bundler/setup"
