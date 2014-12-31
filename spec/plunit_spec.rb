require 'ostruct'
require_relative '../lib/plunit'

include Plunit

describe TestCompiler do
  let(:runner) { TestRunner.new('swipl') }
  let(:file) { OpenStruct.new(path: '/tmp/foo.pl') }

  describe '#run_test_command' do
    it { expect(runner.run_test_command(file)).to include('swipl -f /tmp/foo.pl --quiet -t run_tests') }
    it { expect(runner.run_test_command(file)).to include('2>&1') }
  end

  describe '#validate_compile_errors' do
    let(:results) { runner.validate_compile_errors(file, *original_results) }

    describe 'fails on test errors' do
      let(:original_results) { ['Test failed', :failed] }
      it { expect(results).to eq(original_results) }
    end

    describe 'fails on compile errors ' do
      let(:original_results) { ['ERROR: /tmp/foo.pl:3:0: Syntax error: Operator expected', :passed] }
      it { expect(results).to eq(['ERROR: /tmp/foo.pl:3:0: Syntax error: Operator expected', :failed]) }
    end

    describe 'passes otherwise' do
      let(:original_results) { ['....', :passed] }
      it { expect(results).to eq(['....', :passed]) }
    end
  end
end

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
