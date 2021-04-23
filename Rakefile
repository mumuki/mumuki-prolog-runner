require 'rspec/core/rake_task'
require_relative 'lib/prolog_runner'

RSpec::Core::RakeTask.new(:spec)

task :pull_worker do
  image = Mumukit.config.docker_image
  puts "Fetching image #{image}..."
  Docker::Image.create('fromImage' => image)
end

task :default => :spec
