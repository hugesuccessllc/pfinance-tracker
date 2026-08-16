# frozen_string_literal: true

# Shared Bundler bootstrap for every script in pdf/.
#
# build-slicksheet.rb starts with `require_relative "lib/bootstrap"` as its first line
# (before any other require). That pins gem resolution to pdf/Gemfile — not the empty
# repo-root Gemfile — so plain `ruby pdf/build-slicksheet.rb` resolves this directory's
# gems (prawn, rqrcode) correctly no matter what your working directory is, with no
# `bundle exec` and no manual `BUNDLE_GEMFILE=` prefix. `require_relative` itself needs
# no gems, so it's safe to use before Bundler is set up.
#
# Do NOT invoke this via `bundle exec ruby pdf/build-slicksheet.rb` from the repo root:
# `bundle exec` sets BUNDLE_GEMFILE to the repo-root Gemfile *before* this file ever runs,
# and the `||=` below can't override an already-set env var. That makes Bundler resolve
# against the wrong Gemfile and fail with e.g. "cannot load such file -- prawn" even
# though everything is installed correctly. Plain `ruby` (no `bundle exec`) is the correct
# invocation — see pdf/README.md. If you ever do need `bundle exec` for some other reason,
# prefix it explicitly instead: `BUNDLE_GEMFILE=pdf/Gemfile bundle exec ruby
# pdf/build-slicksheet.rb`.
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)
require "bundler/setup"
