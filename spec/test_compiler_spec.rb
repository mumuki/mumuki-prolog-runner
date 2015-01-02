require_relative '../lib/test_compiler'
require 'ostruct'

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

  describe '#create_compilation_file!' do
    let(:compiler) { TestCompiler.new }
    let(:file) { compiler.create_compilation_file!('bar.', 'foo.') }

    it { expect(File.exists? file.path).to be true }
  end
end
