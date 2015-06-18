require 'i18n'
require 'mumukit'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

module Mumukit::WithCommandLine
  def limit_command
    '.heroku/vendor/bin/limit'
  end
end

require_relative 'lib/plunit'

run Mumukit::TestServerApp
