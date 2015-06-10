require 'mumukit'

class TestCompiler < Mumukit::FileTestCompiler
  def compile(request)
    <<EOF
:- begin_tests(mumuki_submission_test, []).
#{request.test}
#{request.content}
#{request.extra}
:- end_tests(mumuki_submission_test).
EOF
  end
end
