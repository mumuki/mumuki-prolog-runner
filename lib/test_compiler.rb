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

  def self.new_pointer(request)
    ContentPointer.new(request.content, (request.test.length rescue 0) + 1)
  end
end
