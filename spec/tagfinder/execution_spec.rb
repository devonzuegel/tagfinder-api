RSpec.describe Tagfinder::Execution do
  let(:path_to_file) { File.join(%w[. path to file.rb]) }
  let(:downloader)   { instance_double(described_class::Downloader, call: path_to_file) }
  let(:preparer)     { instance_double(described_class::Preparer) }
  let(:cli)          { instance_double(Tagfinder::CommandLine) }

  describe '.call' do
    it 'runs the execution' do
      skip
      ap downloader
      ap preparer
      ap command_line
    end
  end
end
