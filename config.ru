require 'i18n'
require 'mumukit'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require_relative 'lib/plunit_server'

run Mumukit::TestServerApp
