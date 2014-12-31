class Plunit::TestCompiler
  include Mumuki::FileTestCompiler

  def compile(test_src, content_src)
    <<EOF
:- begin_tests(mumuki_submission_test, []).
#{test_src}
#{content_src}
:- end_tests(mumuki_submission_test).
EOF
  end

end
