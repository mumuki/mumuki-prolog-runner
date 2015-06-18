require_relative 'spec_helper'

describe FeedbackRunner do
  before { I18n.locale = :es }
  let(:runner) { FeedbackRunner.new(nil) }
  let!(:feedback) { runner.run_feedback!(request, results) }

  context 'when wrong distinct operator' do
    let(:request) { OpenStruct.new(content: 'foo(X) :- X != 2') }
    let(:results) { OpenStruct.new(test_results: '') }

    it { expect(feedback).to eq 'Recordá que el predicado infijo distinto en prolog se escribe así: \=' }
  end


  context 'when wrong distinct operator' do
    let(:request) { OpenStruct.new(content: '
foo(X) :- bar(X).
bar(3).
foo(2).') }

    let(:results) { OpenStruct.new(test_results: '
Warning: /home/franco/tmp/mumuki-plunit-server/foo.pl:3:
	Clauses of foo/1 are not together in the source-file
% foo compiled 0.00 sec, 4 clauses') }

    it { expect(feedback).to eq 'Recordá que es una buena práctica escribir toda las cláusulas de un mismo predicado juntas' }
  end


end
