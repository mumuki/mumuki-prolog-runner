require 'sinatra'
require 'yaml'
require 'json'
require_relative './lib/plunit'

config = YAML.load_file('config/application.yml')

compiler = Plunit::TestCompiler.new
runner = Plunit::TestRunner.new(config['test_runner_command'])

def parse_test_body(request)
  compilation = JSON.parse request.body.read
  [compilation['test'], compilation['content']]
end

post '/test' do
  begin
    test, content = parse_test_body request
    file = compiler.create_compilation_file!(test, content)
    results = runner.run_test_file!(file)
    file.unlink
    JSON.generate(exit: results[1], out: results[0])
  rescue Exception => e
    JSON.generate(exit: 'failed', out: e.message)
  end
end

get '/*' do
  redirect config['mumuki_url']
end
