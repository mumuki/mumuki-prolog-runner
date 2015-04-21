require_relative '../lib/expectations_runner'

describe ExpectationsRunner do
  let(:json) {
    {expectations: [
        {binding: 'foo', inspection: 'HasBinding'},
    ]}
  }
  let(:json_with_not) {
    {expectations: [
        {binding: 'bar', inspection: 'Not:HasBinding'}
    ]}
  }
  let(:json_with_usage) {
    {expectations: [
        {binding: 'foo', inspection: 'HasUsage:bar'}
    ]}
  }

  it { expect(ExpectationsRunner.expectations_to_terms(json)).to eq "[expectation('foo',inspection('HasBinding'))]" }
  it { expect(ExpectationsRunner.expectations_to_terms(json_with_not)).to eq "[expectation('bar',not(inspection('HasBinding'))]" }
  it { expect(ExpectationsRunner.expectations_to_terms(json_with_usage)).to eq "[expectation('foo',inspection('HasUsage',bar))]" }
end
