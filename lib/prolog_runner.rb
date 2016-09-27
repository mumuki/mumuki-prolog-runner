require 'i18n'

I18n.load_path += Dir[File.join('.', 'locales', '*.yml')]

require 'mumukit'

Mumukit.runner_name = 'prolog'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-plunit-worker'
  config.content_type = 'markdown'
end

require_relative 'test_hook'
require_relative 'query_hook'
require_relative 'expectations_hook'
require_relative 'metadata_hook'
require_relative 'feedback_hook'


