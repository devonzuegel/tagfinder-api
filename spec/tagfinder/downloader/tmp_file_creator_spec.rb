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
