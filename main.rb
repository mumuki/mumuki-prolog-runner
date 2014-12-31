require 'sinatra'
require 'yaml'
require 'json'
require_relative './lib/plunit'

config = YAML.load_file('config/application.yml')

def create_compilation_file!(compilation)
  file = Tempfile.new("mumuki.#{id}.compile")
  file.write(compilation)
  file.close
  file
end

post '/test' do
  compilation = JSON.parse request.body.read
  runner = PLUnitRunner.new(config['swipl_path'])
  file = create_compilation_file!(compilation)
  results = runner.run_test_file!(file)
  file.unlink
  JSON.generate(results)
end

get '/*' do
  redirect config['mumuki_url']
end
