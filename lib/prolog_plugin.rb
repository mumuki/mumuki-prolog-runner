require_relative '../lib/command_line_plugin'

class PrologPlugin
  include CommandLinePlugin

  attr_accessor :swipl_path

  def initialize(swipl_path)
    self.swipl_path = swipl_path
  end

  def image_url
    'http://cdn.portableapps.com/SWI-PrologPortable_128.png'
  end

  def run_test_file!(file)
    validate_compile_errors(file, *super)
  end

  def validate_compile_errors(file, result, status)
    if /ERROR: #{file.path}:.*: Syntax error: .*/ =~ result
      [result, :failed]
    else
      [result, status]
    end
  end

  def run_test_command(file)
    "#{swipl_path} -f #{file.path} --quiet -t run_tests 2>&1"
  end

  def compile(test_src, submission_src)
    <<EOF
:- begin_tests(mumuki_submission_test, []).
#{test_src}
#{submission_src}
:- end_tests(mumuki_submission_test).
EOF
  end

end
