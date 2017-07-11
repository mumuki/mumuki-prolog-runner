require_relative 'spec_helper'

describe PrologExpectationsHook do
  def req(expectations, content)
    struct expectations: expectations, content: content
  end

  def compile_and_run(request)
    runner.run!(runner.compile(request))
  end

  let(:runner) { PrologExpectationsHook.new(mulang_path: './bin/mulang') }
  let(:result) { compile_and_run(req(expectations, code)) }

  describe 'UsesCut' do
    let(:code) { "foo(X) :- !.\nbar(X)." }
    let(:expectations) { [] }

    it { expect(result).to eq [{expectation: {binding: 'foo', inspection: 'UsesCut'}, result: false}] }
  end

  describe 'HasRedundantReduction' do
    let(:code) { "foo(X) :- X is 7." }
    let(:expectations) { [] }

    it { expect(result).to eq [{expectation: {binding: 'foo', inspection: 'HasRedundantReduction'}, result: false}] }
  end

  describe 'UsesUnificationOperator' do
    let(:code) { "foo(X, Y) :- X = Y." }
    let(:expectations) { [] }

    it { expect(result).to eq [{expectation: {binding: 'foo', inspection: 'UsesUnificationOperator'}, result: false}] }
  end

  describe 'UsesForall' do
    let(:code) { "foo(X, Y) :- m(X, Y).\nbar(X) :- forall(g(X), h(X))." }
    let(:expectations) { [
      {binding: 'foo', inspection: 'UsesForall'},
      {binding: 'bar', inspection: 'UsesForall'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: false},
        {expectation: expectations[1], result: true}] }
  end

  describe 'UsesFindall' do
    let(:code) { "foo(X, Y) :- m(X, Y).\nbar(X, Ms) :- findall(M, h(X), Ms)." }
    let(:expectations) { [
      {binding: 'foo', inspection: 'UsesFindall'},
      {binding: 'bar', inspection: 'UsesFindall'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: false},
        {expectation: expectations[1], result: true}] }
  end

  describe 'Uses' do
    let(:code) { "foo(X, Y) :- m(X, Y).\nbar(X, Ms) :- findall(M, h(X), Ms)." }
    let(:expectations) { [
      {binding: 'foo', inspection: 'Uses:m'},
      {binding: 'bar', inspection: 'Uses:m'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: true},
        {expectation: expectations[1], result: false}] }
  end

  describe 'DeclaresPredicate' do
    let(:code) { "foo(X, Y) :- m(X, Y)." }
    let(:expectations) { [
      {binding: '', inspection: 'DeclaresPredicate:foo'},
      {binding: '', inspection: 'DeclaresPredicate:bar'}] }

    it { expect(result).to eq [
        {expectation: expectations[0], result: true},
        {expectation: expectations[1], result: false}] }
  end
end
