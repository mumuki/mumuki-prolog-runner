class TestRunner
  def post_process_file(file, result, status)
    if /ERROR: #{file.path}:.*: Syntax error: .*/ =~ result
      [result, :failed]
    else
      [result, status]
    end
  end

  def run_test_command(file)
    "#{swipl_path} -f #{file.path} --quiet -t run_tests 2>&1"
  end

  private

  def swipl_path
    @config['swipl_command']
  end
end
