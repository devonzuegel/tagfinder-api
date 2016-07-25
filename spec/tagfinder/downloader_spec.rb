RSpec.describe Tagfinder::Downloader do
  let(:url)             { 'http://example.com/blah.mzxml' }
  let(:local_path)      { Pathname.new('subdir').join('blah.mzxml') }
  let(:body)            { 'this is the body of the file' }
  let(:full_local_path) { Pathname.new(described_class::TmpFileCreator::DIR).join(local_path) }
  let(:connection)      { described_class::Connection }
  let(:file_creator)    { described_class::TmpFileCreator }

  before { allow(connection).to receive(:call).and_return(body) }
  before { allow(file_creator).to receive(:call).and_return(full_local_path) }

  it 'retrieves the body of the requested file' do
    expect(connection)
      .to receive(:call)
      .with(Tagfinder::Downloader::Request.new(url))
      .and_return(body)
    described_class.call(url, local_path)
  end

  it 'retrieves the body of the file and saves it to the local path' do
    expect(file_creator)
      .to receive(:call)
      .with(local_path, body)
      .and_return(local_path)
    described_class.call(url, local_path)
  end
end

RSpec.describe Tagfinder::Downloader::TmpFileCreator do
  let(:basename) { 'test.txt' }
  let(:dir_path) { Pathname.new('extra-dir') }
  let(:filepath) { dir_path.join(basename) }
  let(:content)  { 'this is the content of the file' }

  before { allow(File).to receive(:write) }
  before { allow(FileUtils).to receive(:mkdir_p) }

  it 'has the expected tmp dir' do
    expect(described_class::DIR.to_s).to end_with 'tagfinder/tagfinder-api/tmp'
  end

  it 'creates a file at the given path with the given body' do
    described_class.call(basename, content)
    expect(File)
      .to have_received(:write)
      .with(described_class::DIR.join(basename), content)
  end

  context 'path contains nested directories' do
    before { allow(File).to receive(:exist?).and_return(false) }

    it 'creates directories in path if they do not yet exist' do
      described_class.call(filepath, content)
      expect(FileUtils)
        .to have_received(:mkdir_p)
        .with(described_class::DIR.join(dir_path).to_s)
    end

    it 'creates file in nested tmp directory' do
      described_class.call(filepath, content)
      expect(File)
        .to have_received(:write)
        .with(described_class::DIR.join(filepath), content)
    end

    it 'returns the path to the downloaded file' do
      expect(described_class.call(filepath, content))
        .to eql described_class::DIR.join(filepath)
    end
  end
end

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
