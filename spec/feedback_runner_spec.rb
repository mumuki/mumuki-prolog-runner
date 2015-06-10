require '../lib/feedback_runner'
require 'ostruct'

describe FeedbackRunner do
  let(:runner) { FeedbackRunner.new(nil) }
  let!(:feedback) { runner.run_feedback!(request, results) }

  context 'when foo' do
    let(:request) { OpenStruct.new }
    let(:results) { OpenStruct.new }

    it { expect(feedback).to eq '' }
  end

end
