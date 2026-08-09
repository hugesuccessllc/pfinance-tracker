# frozen_string_literal: true

# Captures $stdout inside the block and returns it as a string — used for specs that
# exercise CLI-adjacent code paths (e.g. `warn`/`puts` in a guarded `if $PROGRAM_NAME ==
# __FILE__` block invoked in-process via `load`) without letting test output clutter the
# real rspec run.
module OutputCapture
  def capture_stdout
    original = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original
  end

  def capture_stderr
    original = $stderr
    $stderr = StringIO.new
    yield
    $stderr.string
  ensure
    $stderr = original
  end
end
