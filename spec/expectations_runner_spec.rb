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

  let(:runner) { ExpectationsRunner.new(nil) }

  it { expect(runner.expectations_to_terms(expectations)).to eq "[expectation('foo',inspection('HasBinding'))]" }
  it { expect(runner.expectations_to_terms(expectations_with_not)).to eq "[expectation('bar',not(inspection('HasBinding')))]" }
  it { expect(runner.expectations_to_terms(expectations_with_usage)).to eq "[expectation('foo',inspection('HasUsage','bar'))]" }

  it { expect(runner.run_expectations!(expectations, 'foo(2).')).to eq(
      'expectationResults' => [
          { 'expectation' => expectations[0],'result' => true }]) }

  it { expect(runner.run_expectations!(expectations, 'bar(2).')).to eq(
      'expectationResults' => [
          { 'expectation' => expectations[0], 'result' => false }]) }

  it 'Prolog tests pass' do
    out = %x{swipl -f expectations/*_tests.pl --quiet -t run_tests 2>&1}
    puts out
    expect($?.success?).to be true
  end

end
