require_relative 'spec_helper'

describe PrologTestHook do
  def req(test, extra, content)
    OpenStruct.new(test:test, extra:extra, content: content)
  end

  true_test = <<EOT
test(the_truth) :-
  assertion(true == true).
EOT

  compiled_test_submission = <<EOT
:- begin_tests(mumuki_submission_test, []).
test(the_truth) :-
  assertion(true == true).


foo(_).
:- end_tests(mumuki_submission_test).
EOT

  describe '#compile' do
    let(:compiler) { PrologTestHook.new(nil) }
    it { expect(compiler.compile_file_content(req(true_test, 'foo(_).',  ''))).to eq(compiled_test_submission) }
  end
end
