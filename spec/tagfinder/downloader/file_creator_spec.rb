RSpec.describe Tagfinder::Downloader::FileCreator do
  let(:filename) { 'test.txt' }
  let(:content)  { 'this is the content of the file' }

  before do
    stub_const('MyFileCreator', Class.new(described_class))

    class MyFileCreator < described_class
      DIR = Pathname.new('dir1').join('dir2').expand_path
    end
  end

  before { allow(File).to receive(:write) }

  it 'creates a file at the given path with the given body' do
    MyFileCreator.call(filename, content)
    expect(File)
      .to have_received(:write)
      .with(MyFileCreator::DIR.join(filename), content)
  end
end

RSpec.describe Tagfinder::Downloader::TmpFileCreator do
  let(:filename) { 'test.txt' }
  let(:uuid)     { 'lasdkfjadlskfj' }
  let(:content)  { 'this is the content of the file' }

  before do
    allow(File).to receive(:write)
    allow(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  it 'tmp exists in filesystem' do
    expect(described_class::DIR.directory?).to eql true
  end

  it 'creates the file with a random prefix' do
    described_class.call(filename, content)
    expect(File)
      .to have_received(:write)
      .with(described_class::DIR.join("#{uuid}-#{filename}"), content)
  end

  it 'returns a filename with a random prefix' do
    expect(described_class.call(filename, content))
      .to eql described_class::DIR.join("#{uuid}-#{filename}")
  end
end

RSpec.describe Tagfinder::Downloader::MzxmlFileCreator do
  let(:mzxml_filename) { 'test.mzXML' }
  let(:txt_filename)   { 'test.txt' }
  let(:uuid)           { 'lasdkfjadlskfj' }

  before do
    allow(File).to receive(:write)
    allow(SecureRandom).to receive(:uuid).and_return(uuid)
  end

  describe 'data directory' do
    it 'exists in filesystem' do
      expect(described_class::DIR.directory?).to eql true
    end
  end

  it 'requires the given file to be an .mzXML file' do
    expect { described_class.call(txt_filename, 'junk') }
      .to raise_error ArgumentError, "Data must be an .mzXML file, but given #{txt_filename}"
  end

  it 'creates the file with a random prefix' do
    described_class.call(mzxml_filename, 'junk')
    expect(File)
      .to have_received(:write)
      .with(described_class::DIR.join("#{uuid}-#{mzxml_filename}"), 'junk')
  end

  it 'returns a filename with a random prefix' do
    expect(described_class.call(mzxml_filename, 'junk'))
      .to eql described_class::DIR.join("#{uuid}-#{mzxml_filename}")
  end
end

RSpec.describe Tagfinder::Downloader::ParamsFileCreator do
  describe 'params directory' do
    it 'exists in filesystem' do
      expect(described_class::DIR.directory?).to eql true
    end
  end
end
