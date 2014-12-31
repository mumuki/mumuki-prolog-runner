require 'sinatra'
require 'yaml'
require 'json'
require_relative './lib/plunit'

config = YAML.load_file('config/application.yml')

compiler = Plunit::TestCompiler.new
runner = Plunit::TestRunner.new(config['test_runner_command'])

post '/test' do
  compilation = JSON.parse request.body.read
  test = compilation['test']
  content = compilation['content']

  file = compiler.create_compilation_file!(test, content)
  results = runner.run_test_file!(file)

  file.unlink

  JSON.generate(exit: results[0], out: results[1])
end

get '/*' do
  redirect config['mumuki_url']
end
