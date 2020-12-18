# frozen_string_literal: true

Spring.watch(
  '.ruby-version',
  '.rbenv-vars',
  'tmp/restart.txt',
  'tmp/caching-dev.txt'
)
# rubocop:disable Style/SafeNavigation, Layout/EmptyLineAfterGuardClause, Performance/RegexpMatch, Performance/StringInclude, Style/StringConcatenation
Spring.after_fork do
  if ENV['DEBUGGER_STORED_RUBYLIB']
    ENV['DEBUGGER_STORED_RUBYLIB'].split(File::PATH_SEPARATOR).each do |path|
      next unless path =~ /ruby-debug-ide/
      load path + '/ruby-debug-ide/multiprocess/starter.rb'
    end
  end
end
# rubocop:enable Style/SafeNavigation, Layout/EmptyLineAfterGuardClause, Performance/RegexpMatch, Performance/StringInclude, Style/StringConcatenation
