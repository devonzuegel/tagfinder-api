RSpec.describe Tagfinder::Retrier do
  before { Retries.sleep_enabled = true }
  let(:error)      { Errno::ENOENT }
  let(:max_tries)  { 2 }
  let(:options) do
    {
      max_tries:          max_tries,
      base_sleep_seconds: 0.00001,
      max_sleep_seconds:  0.00001,
      handler:            proc {}
    }
  end

  it 'does not accept options with :rescue key' do
    expect { described_class.call(Exception, proc { next }, rescue: 'junk') }
      .to raise_error ArgumentError
  end

  it 'prints the handler message to stdout' do
    opts = options.merge(handler: proc { print 'custom handler' })
    expect { described_class.call(error, proc { |i| fail error if i == 1 }, opts) }
      .to output('custom handler').to_stdout
  end

  it 'retries on failure' do
    described_class.call(error, proc { |i| fail error if i < max_tries }, options)
  end

  it 'raises error if failure continues past max_tries' do
    expect { described_class.call(error, proc { fail error }, options) }
      .to raise_error error
  end
end
