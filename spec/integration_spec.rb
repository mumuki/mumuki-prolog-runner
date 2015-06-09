require 'mumukit/bridge'

describe 'runner' do
  let(:bridge) { Mumukit::Bridge::Bridge.new('http://localhost:4567') }

  before(:all) do
    @pid = Process.spawn 'rackup -p 4567', err: '/dev/null'
    sleep 3
  end
  after(:all) { Process.kill 'TERM', @pid }

  it 'answers a valid hash when submission is ok' do
    response = bridge.run_tests!(test: 'test(ok) :- foo(X), assertion(1 == X).',
                                 extra: '',
                                 content: 'foo(1).',
                                 expectations: [])

    expect(response).to eq(status: 'passed', result: ".\n", expectation_results: [], feedback:'')
  end

  it 'answers a valid hash when submission is ok but expectations failed' do
    response = bridge.run_tests!(test: 'test(ok) :- foo(X), assertion(1 == X).',
                                 extra: 'foo(1).',
                                 content: '',
                                 expectations: [{inspection: 'HasArity:2', binding: 'foo'}])

    expect(response).to eq(status: 'passed',
                           result: ".\n",
                           expectation_results: [binding: 'foo', inspection: 'HasArity:2', result: :failed],
                           feedback:'')
  end

  it 'answers a valid hash when submission is not ok' do
    response = bridge.
        run_tests!(test: 'test(ok) :- foo(X), assertion(1 == X).',
                   extra: '',
                   content: 'foo(2).',
                   expectations: [{inspection: 'HasBinding', binding: 'foo'}]).
        reject { |k, _v| k == :result }

    expect(response).to eq(status: 'failed',
                           expectation_results: [{inspection: 'HasBinding', binding: 'foo', result: :passed}],
                           feedback:'')
  end


end
