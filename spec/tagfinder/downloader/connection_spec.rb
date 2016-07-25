RSpec.describe Tagfinder::Downloader::Connection do
  let(:request)   { 'dummy url' }
  let(:response)  { 'hi' }
  let(:fake_http) { class_double(HTTP, get: instance_double(HTTP::Response, body: response)) }

  before { stub_const('HTTP', fake_http) }

  it 'makes a request to the given url' do
    described_class.call(request)
    expect(fake_http).to have_received(:get).with(request)
  end

  it 'retrieves the body of the response' do
    expect(described_class.call(request)).to eql response
  end
end
