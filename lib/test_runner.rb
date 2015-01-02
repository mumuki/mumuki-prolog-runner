require_relative 'mumukit'

class TestRunner
  include Mumukit::CommandLineTestRunner

  attr_accessor :swipl_path

  def initialize(swipl_path)
    self.swipl_path = swipl_path
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

end
