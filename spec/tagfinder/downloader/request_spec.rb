RSpec.describe Tagfinder::Downloader::Request do
  let(:valid_http)  { 'http://example.com' }
  let(:valid_https) { 'https://example.com' }
  let(:bad_uri)     { 'dummy url' }
  let(:bad_str)     { 'laskdfj' }

  it 'initializes a request from a valid http url' do
    expect(described_class.new(valid_http).to_s).to eq valid_http
  end

  it 'initializes a request from a valid https url' do
    expect(described_class.new(valid_https).to_s).to eq valid_https
  end

  it 'fails when given a non-uri' do
    expect { described_class.new(bad_uri) }.to raise_error URI::InvalidURIError
  end

  it 'fails when given a string without spaces' do
    expect { described_class.new(bad_str) }.to raise_error URI::InvalidURIError
  end
end