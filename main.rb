require 'sinatra'
require 'yaml'
require 'json'
require_relative './lib/plunit'

config = YAML.load_file('config/application.yml')

post '/test' do
  compilation = JSON.parse request.body.read
  test = compilation['test']
  content = compilation['content']

  compiler = Plunit::TestCompiler.new
  file = compiler.create_compilation_file!(test, content)

  runner = Plunit::TestRunner.new(config['swipl_path'])
  results = runner.run_test_file!(file)

  file.unlink

  JSON.generate(exit: results[0], out: results[1])
end

get '/*' do
  redirect config['mumuki_url']
end
