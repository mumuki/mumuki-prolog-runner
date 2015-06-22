require_relative 'spec_helper'

class FilePointer
  def initialize(offset=0)
    @offset = offset
  end

  def line_at(n, text)
    text.split("\n")[line_number n]
  end

  def line_number(n)
    n - @offset
  end
end

describe FilePointer do

  let(:text) { "foo\nbar\nbaz" }

  context 'without offset' do
    let(:pointer) { FilePointer.new }
    it { expect(pointer.line_at(0, text)).to eq 'foo' }
    it { expect(pointer.line_at(1, text)).to eq 'bar' }
    it { expect(pointer.line_at(2, text)).to eq 'baz' }
    it { expect(pointer.line_number(2)).to eq 2 }

  end

  context 'with offset' do
    let(:pointer) { FilePointer.new(10) }
    it { expect(pointer.line_at(10, text)).to eq 'foo' }
    it { expect(pointer.line_at(11, text)).to eq 'bar' }
    it { expect(pointer.line_at(12, text)).to eq 'baz' }
    it { expect(pointer.line_number(12)).to eq 2 }
  end
end
