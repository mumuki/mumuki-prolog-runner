require_relative '../lib/expectations_runner'

describe ExpectationsRunner do
  let(:expectations) {
    [{'binding' => 'foo', 'inspection' => 'HasBinding'}]
  }
  let(:expectations_with_not) {
    [{'binding' => 'bar', 'inspection' => 'Not:HasBinding'}]
  }
  let(:expectations_with_usage) {
    [{'binding' => 'foo', 'inspection' => 'HasUsage:bar'}]
  }

  it { expect(ExpectationsRunner.expectations_to_terms(expectations)).to eq "[expectation('foo',inspection('HasBinding'))]" }
  it { expect(ExpectationsRunner.expectations_to_terms(expectations_with_not)).to eq "[expectation('bar',not(inspection('HasBinding')))]" }
  it { expect(ExpectationsRunner.expectations_to_terms(expectations_with_usage)).to eq "[expectation('foo',inspection('HasUsage','bar'))]" }
end
