RSpec.describe Tagfinder::Retrier do
  before { Retries.sleep_enabled = true }
  let(:error_type) { Errno::ENOENT }
  let(:max_tries)  { 2 }
  let(:options) do
    {
      max_tries:          max_tries,
      base_sleep_seconds: 0.00001,
      max_sleep_seconds:  0.00001
    }
  end

  it 'shouldnt accept options with :rescue key' do
    expect { described_class.call(Exception, proc { next }, rescue: 'junk') }
      .to raise_error ArgumentError
  end

  it 'should retry on failure' do
    described_class.call(error_type, proc { |i| fail error_type if i < max_tries }, options)
  end

  it 'raise error if failure continues past max_tries' do
    expect { described_class.call(error_type, proc { fail error_type }, options) }
      .to raise_error error_type
  end
end
