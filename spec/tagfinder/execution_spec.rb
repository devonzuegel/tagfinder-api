RSpec.describe Tagfinder::Execution do
  CURRENT_DIR = Pathname.new('.').expand_path

  let(:history) do
    [{
      command: "bin/tagfinder-mac #{CURRENT_DIR}/tmp/data/xxx-blah.mzxml " \
               "#{CURRENT_DIR}/tmp/params/xxx-google.com",
      status:  1,
      stderr:  '',
      stdout:  "TextSection::load_file: error opening file \"#{CURRENT_DIR}" \
               "/tmp/params/xxx-google.com\"\n"
    }]
  end

  let(:result) { { history: history, results_urls: [] } }
  let(:cli) { Sinatra::Base.development? ? Tagfinder::MacCLI.new : Tagfinder::UbuntuCLI.new }

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
end
