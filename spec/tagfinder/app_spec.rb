RSpec.describe Tagfinder::App do
  include Rack::Test::Methods

  before do
    stub_const('ENV', ENV.to_hash.merge('TAGFINDER_KEY' => 'expected_password_key'))
  end

  let(:app) { described_class }

  it 'should require the expected keys' do
    get '/tagfinder'
    expect(JSON.parse(last_response.body)).to eql(
      'error' => "Provided parameters don't match expected parameters:\n"   \
                 "  Provided: []\n  Missing:  [\"data_url\", \"key\"]\n\n" \
                 "  Expected: [\"data_url\", \"key\"]\n"                    \
                 "  Optional: [\"params_url\"]\n"
    )
  end

  it 'should require the expected password' do
    get '/tagfinder', key: 'JUNK', data_url: 'blah'
    expect(JSON.parse(last_response.body)).to eql('error' => 'Incorrect password')
  end

  it 'should not accept bad urls' do
    get '/tagfinder', key: 'expected_password_key', data_url: 'baduri'
    expect(JSON.parse(last_response.body)).to eql('error' => 'URI::InvalidURIError')
  end

  context 'valid inputs' do
    before { allow(SecureRandom).to receive(:uuid).and_return('x') }

    let(:data_url) { 'https://regis-web.systemsbiology.net/rawfiles/lcq/blah.mzXML' }

    let(:expected_cmd) do
      "bin/tagfinder-mac #{Pathname.new('').expand_path}/tmp/data/x-blah.mzXML"
    end

    let(:execution_response) do
      [{
        'command' => expected_cmd,
        'status'  => 0,
        'stderr'  => '',
        'stdout'  => 'expected stdout'
      }]
    end

    before do
      stub_const(
        'Tagfinder::Execution',
        class_double(Tagfinder::Execution, call: execution_response)
      )
    end

    it 'when given a valid input, return the output of the execution' do
      get '/tagfinder', key: 'expected_password_key', data_url: data_url
      expect(JSON.parse(last_response.body)).to eql(execution_response)
    end
  end
end
