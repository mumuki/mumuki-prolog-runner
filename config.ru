require 'mumukit'

module Mumukit::WithCommandLine
  def limit_command
    '.heroku/vendor/bin/limit'
  end
end
require_relative 'lib/test_compiler'
require_relative 'lib/test_runner'
require_relative 'lib/expectations_runner'

run Mumukit::TestServerApp
