require_relative 'spec_helper'

describe ExpectationsHook do
  def req(expectations, content)
    OpenStruct.new(expectations:expectations, content:content)
  end

  let(:expectations) {
    [{'binding' => 'foo', 'inspection' => 'HasBinding'}]
  }
  let(:expectations_with_not) {
    [{'binding' => 'bar', 'inspection' => 'Not:HasBinding'}]
  }
  let(:expectations_with_usage) {
    [{'binding' => 'foo', 'inspection' => 'HasUsage:bar'}]
  }
  let(:multiple_expectations) {
    [{'binding' => 'foo', 'inspection' => 'Not:HasBinding'}, {'binding' => 'foo', 'inspection' => 'HasUsage:bar'}]
  }

  let(:runner) { ExpectationsHook.new('swipl_path' => 'swipl') }

  def compile_and_run(runner, request)
    runner.run!(runner.compile(request))
  end

  it { expect(ExpectationsFile.expectations_to_terms(expectations)).to eq "[expectation('foo',inspection('HasBinding'))]" }
  it { expect(ExpectationsFile.expectations_to_terms(expectations_with_not)).to eq "[expectation('bar',not(inspection('HasBinding')))]" }
  it { expect(ExpectationsFile.expectations_to_terms(expectations_with_usage)).to eq "[expectation('foo',inspection('HasUsage','bar'))]" }
  it { expect(ExpectationsFile.expectations_to_terms(multiple_expectations)).to eq "[expectation('foo',not(inspection('HasBinding'))),expectation('foo',inspection('HasUsage','bar'))]" }

  it { expect(compile_and_run(runner, req(expectations, 'foo(2).'))).to eq(
      [ { 'expectation' => expectations[0],'result' => true }]) }

  it { expect(compile_and_run(runner, req(expectations, 'bar(2).'))).to eq(
      [ { 'expectation' => expectations[0], 'result' => false }]) }

  it { expect(compile_and_run(runner, req(multiple_expectations, 'bar(2).'))).to eq(
      [ { 'expectation' => multiple_expectations[0], 'result' => true },
        { 'expectation' => multiple_expectations[1], 'result' => false }]) }

end
