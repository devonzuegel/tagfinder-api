RSpec.describe Tagfinder::Downloader do
  let(:url)             { 'http://example.com/blah.mzxml' }
  let(:filename)        { 'blah.mzxml' }
  let(:body)            { 'this is the body of the file' }
  let(:connection)      { double(described_class::Connection) }
  let(:file_creator)    { double(described_class::FileCreator) }

  before { allow(connection).to receive(:call).and_return(body) }
  before { allow(file_creator).to receive(:call).and_return(Pathname.new('tmp')) }

  it 'retrieves the body of the requested file' do
    expect(connection)
      .to receive(:call)
      .with(Tagfinder::Downloader::Request.new(url))
      .and_return(body)

    described_class.call(
      url:          url,
      filename:     filename,
      file_creator: file_creator,
      connection:   connection
    )
  end

  it 'retrieves the body of the file and saves it to the local path' do
    expect(file_creator)
      .to receive(:call)
      .with(filename, body)
      .and_return(filename)

    described_class.call(
      url:          url,
      filename:     filename,
      file_creator: file_creator,
      connection:   connection
    )
  end
end
