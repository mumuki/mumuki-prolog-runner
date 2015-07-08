require_relative 'spec_helper'

describe FeedbackRunner do
  before { I18n.locale = :es }

  let(:server) { Mumukit::TestServer.new({'swipl_command' => 'swipl'}) }

  let!(:feedback) { server.run!(request)[:feedback] }

  context 'when wrong distinct operator' do
    let(:request) { OpenStruct.new(
        content: 'foo(X) :- X != 2'
    )}

    it { expect(feedback).to eq(
"* Cuidado, tenés errores de sintaxis. Revisá que el código esté bien escrito
* Revisá esta parte: `...(X) :- X != 2...`. Recordá que el predicado infijo distinto en prolog se escribe así: `\\=`") }
  end

  context 'when clauses not together' do
    let(:request) { OpenStruct.new(
        content: '
foo(X) :- bar(X).
bar(3).
foo(2).')}

    it { expect(feedback).to eq(
'* Revisá el predicado `foo/1`. Recordá que es una buena práctica escribir toda las cláusulas de un mismo predicado juntas') }
  end


  context 'when singleton variables' do
    let(:request) { OpenStruct.new(
        content: 'foo(X, Y) :- bar(X).')}

    it { expect(feedback).to eq '* Tenés variables `Y` sin usar' }
  end


  context 'when syntax error' do
    let(:request) { OpenStruct.new(
        content: 'foo(X, Y) bar(X).')}

    it { expect(feedback).to eq '* Cuidado, tenés errores de sintaxis. Revisá que el código esté bien escrito' }
  end

  context 'when missing predicate used' do
    let(:request) { OpenStruct.new(
        content: 'foo(X, 2) :- bar(X).',
        test: 'test(foo) :- foo(2, 2).' )}

    it { expect(feedback).to eq(
'* Revisá el predicado `foo/2`. Parece que intentaste usar `bar/1`, pero no existe. ¿Habrás escrito mal su nombre o pasado una cantidad incorrecta de argumentos?') }
  end


  context 'when missing predicate tested' do
    let(:request) { OpenStruct.new(
        content: 'foo(X, 2) :- bar(X).',
        test: 'test(foo) :- foo(2).' )}

    it { expect(feedback).to be_blank }
  end


  context 'when missing predicate tested' do
    let(:request) { OpenStruct.new(
        content: 'foo(2) :- bar(X)',
        test: 'test(foo) :- foo(2).' )}

    it { expect(feedback).to be_blank }
  end

  context 'when not sufficiently instantiated' do
    let(:request) { OpenStruct.new(
        content: 'foo(2) :- bar(X)',
        test: 'test(foo) :- X is Y + 2, foo(Y, X).' )}

    it { expect(feedback).to include('* Ojo con la inversibilidad de `is/2`. Cuando lo uses, asegurate de generar todos su argumentos no inversibles') }
  end

end
