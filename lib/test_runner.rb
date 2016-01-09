class TestRunner < Mumukit::FileTestRunner
  include Mumukit::WithEmbeddedEnvironment

  def post_process_file(file, result, status)
    if /ERROR: #{file.path}:.*: Syntax error: .*/ =~ result
      [format_code(result), :failed]
    elsif /Caught signal 24 \(xcpu\)/ =~ result
      [format_code(I18n.t(:time_exceeded)), :failed]
    else
      [format_code(result), status]
    end
  end

  def run_test_command(filename)
    "#{swipl_path} -f #{filename} --quiet -t run_tests 2>&1"
  end

  private

  def format_code(code)
    "```\n#{code}\n```"
  end
end
