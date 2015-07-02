require 'i18n'
require 'ostruct'

require_relative '../lib/plunit'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]
