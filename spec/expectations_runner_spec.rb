require_relative '../lib/expectations_runner'
require 'ostruct'

describe ExpectationsRunner do
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

  let(:runner) { ExpectationsRunner.new('swipl_command' => 'swipl') }

  it { expect(runner.expectations_to_terms(expectations)).to eq "[expectation('foo',inspection('HasBinding'))]" }
  it { expect(runner.expectations_to_terms(expectations_with_not)).to eq "[expectation('bar',not(inspection('HasBinding')))]" }
  it { expect(runner.expectations_to_terms(expectations_with_usage)).to eq "[expectation('foo',inspection('HasUsage','bar'))]" }
  it { expect(runner.expectations_to_terms(multiple_expectations)).to eq "[expectation('foo',not(inspection('HasBinding'))),expectation('foo',inspection('HasUsage','bar'))]" }

  it { expect(runner.run_expectations!(req(expectations, 'foo(2).'))).to eq(
      [ { 'expectation' => expectations[0],'result' => true }]) }

  it { expect(runner.run_expectations!(req(expectations, 'bar(2).'))).to eq(
      [ { 'expectation' => expectations[0], 'result' => false }]) }

  it { expect(runner.run_expectations!(req(multiple_expectations, 'bar(2).'))).to eq(
      [ { 'expectation' => multiple_expectations[0], 'result' => true },
        { 'expectation' => multiple_expectations[1], 'result' => false }]) }

  Dir['expectations/test/*_tests.pl'].each do |test|
    it "Prolog test #{test} pass" do
      out = %x{swipl -f #{test} --quiet -t run_tests 2>&1}
      puts out
      expect($?.success?).to be true
    end
  end


end
