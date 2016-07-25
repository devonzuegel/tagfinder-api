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