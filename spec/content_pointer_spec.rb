require_relative 'spec_helper'

describe ContentPointer do

  let(:text) { "foo\nbar\nbaz" }

  context 'without offset' do
    let(:pointer) { ContentPointer.new(text) }
    it { expect(pointer.line_at(0)).to eq 'foo' }
    it { expect(pointer.line_at(1)).to eq 'bar' }
    it { expect(pointer.line_at(2)).to eq 'baz' }
    it { expect(pointer.line_number(2)).to eq 2 }

  end

  context 'with offset' do
    let(:pointer) { ContentPointer.new(text, 10) }
    it { expect(pointer.line_at(10)).to eq 'foo' }
    it { expect(pointer.line_at(11)).to eq 'bar' }
    it { expect(pointer.line_at(12)).to eq 'baz' }
    it { expect(pointer.line_number(12)).to eq 2 }
  end
end
