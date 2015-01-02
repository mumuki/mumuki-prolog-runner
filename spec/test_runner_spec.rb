require_relative '../lib/test_runner'

describe TestRunner do
  true_test = <<EOT
test(the_truth) :-
  assertion(true == true).
EOT

  compiled_test_submission = <<EOT
:- begin_tests(mumuki_submission_test, []).
test(the_truth) :-
  assertion(true == true).


:- end_tests(mumuki_submission_test).
EOT

  describe '#compile' do
    let(:compiler) { TestCompiler.new }
    it { expect(compiler.compile(true_test, '')).to eq(compiled_test_submission) }
  end

end
