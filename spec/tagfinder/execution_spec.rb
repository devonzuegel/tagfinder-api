RSpec.describe Tagfinder::Execution do
  CURRENT_DIR = Pathname.new('.').expand_path
  let(:cli) { Sinatra::Base.development? ? Tagfinder::MacCLI.new : Tagfinder::UbuntuCLI.new }

  let(:result) do
    [{
      command: "bin/tagfinder-mac #{CURRENT_DIR}/tmp/data/xxx-blah.mzxml " \
               "#{CURRENT_DIR}/tmp/params/xxx-google.com",
      status:  1,
      stderr:  '',
      stdout:  "TextSection::load_file: error opening file \"#{CURRENT_DIR}" \
               "/tmp/params/xxx-google.com\"\n"
    }]
  end

  before do
    allow(SecureRandom).to receive(:uuid).and_return('xxx')
    allow(File).to receive(:write)
    allow(File).to receive(:delete)
  end

  it 'runs a request' do
    expect(
      Tagfinder::Execution.call(
        data_url:   'http://google.com/blah.mzxml',
        params_url: 'http://google.com',
        downloader: Tagfinder::Downloader,
        cli:        cli
      )
    ).to eql(result)
    expect(File).to have_received(:delete).with(
      Pathname.new('tmp').expand_path.join(*%w[data xxx-blah.mzxml]),
      Pathname.new('tmp').expand_path.join(*%w[params xxx-google.com])
    )
  end

  describe 'cli.tagfinder' do
    let(:no_files) do
      {
        command: 'bin/tagfinder-mac',
        status:  0,
        stderr:  '',
        stdout:  File.read(Pathname.new('spec').join('fixtures', 'tagfinder-usage.txt'))
      }
    end

    let(:non_mzxml_file) do
      no_files.merge(
        command: 'bin/tagfinder-mac badfile',
        stderr:  "File name did not end in \".mzxml\".\n"
      )
    end

    let(:bad_mzxml_file) do
      {
        command: 'bin/tagfinder-mac badfile.mzxml',
        status:  1,
        stderr:  "error declared in file [main.cpp] at line 317\nfailed to load mzxml file\n",
        stdout:  File.read(Pathname.new('spec').join('fixtures', 'tagfinder-bad-file.txt'))
      }
    end

    it 'provides usage information when not provided any files' do
      history = cli.tagfinder(data_filepath: nil, params_filepath: nil).history
      expect(history.to_a.first.to_s).to eql(no_files)
    end

    it 'tells user to provide an .mzxml file' do
      history = cli.tagfinder(data_filepath: 'badfile', params_filepath: nil).history
      expect(history.to_a.first.to_s).to eql(non_mzxml_file)
    end

    it 'tells ' do
      history = cli.tagfinder(data_filepath: 'badfile.mzxml', params_filepath: nil).history
      expect(history.to_a.first.to_s).to eql(bad_mzxml_file)
    end
  end
end
