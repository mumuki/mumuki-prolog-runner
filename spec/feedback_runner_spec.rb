require_relative 'spec_helper'

describe FeedbackRunner do
  before { I18n.locale = :es }

  let(:server) { Mumukit::TestServer.new({'swipl_command' => 'swipl'}) }

  let!(:feedback) { server.run!(request)[:feedback] }

  context 'when wrong distinct operator' do
    let(:request) { OpenStruct.new(
        content: 'foo(X) :- X != 2'
    )}

    it { expect(feedback).to include 'Recordá que el predicado infijo distinto en prolog se escribe así: \=' }
  end


  context 'when clauses not together' do
    let(:request) { OpenStruct.new(
        content: '
foo(X) :- bar(X).
bar(3).
foo(2).')}

    it { expect(feedback).to eq 'Recordá que es una buena práctica escribir toda las cláusulas de un mismo predicado juntas' }
  end


  context 'when singleton variables' do
    let(:request) { OpenStruct.new(
        content: 'foo(X, Y) :- bar(X).')}

    it { expect(feedback).to eq 'Tenés variables sin usar' }
  end

end
