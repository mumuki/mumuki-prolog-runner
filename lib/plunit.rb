require 'i18n'
I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require 'mumukit'

require_relative 'test_runner'
require_relative 'test_compiler'
require_relative 'expectations_runner'
require_relative 'query_runner'
require_relative 'feedback_runner'
