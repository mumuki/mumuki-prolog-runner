class PrologTestHook < Mumukit::Templates::FileHook
  isolated true

  def post_process_file(file, result, status)
    if /ERROR: #{file.path}:.*: Syntax error: .*/ =~ result
      [format_code(result), :failed]
    elsif /Caught signal 24 \(xcpu\)/ =~ result
      [format_code(I18n.t(:time_exceeded)), :failed]
    else
      [format_code(result), status]
    end
  end

  def command_line(filename)
    "swipl -f #{filename} --quiet -t run_tests 2>&1"
  end

  def format_code(code)
    "```\n#{code}\n```"
  end

  def compile_file_content(request)
    <<EOF
:- begin_tests(mumuki_submission_test, []).
#{request.test}
#{request.content}
#{request.extra}
:- end_tests(mumuki_submission_test).
EOF
  end
end
