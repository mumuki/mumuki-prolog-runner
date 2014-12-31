require '../lib/plunit'

describe Plunit::TestCompiler do
  describe '#create_compilation_file!' do
    let(:compiler) { Plunit::TestCompiler.new }
    let(:file) { compiler.create_compilation_file!('bar.', 'foo.') }

    it { expect(File.exists? file.path).to be_true }
  end
end
