require_relative '../lib/test_compiler'
require 'ostruct'

describe TestCompiler do
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
    let(:compiler) { TestCompiler.new(nil) }
    it { expect(compiler.compile(true_test, '')).to eq(compiled_test_submission) }
  end

  describe '#create_compilation_file!' do
    let(:compiler) { TestCompiler.new(nil) }
    let(:file) { compiler.create_compilation_file!('bar.', 'foo.') }

    it { expect(File.exists? file.path).to be true }
  end
end
