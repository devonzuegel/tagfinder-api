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

  let(:execution_opts) do
    {
      data_url:   'http://google.com/blah.mzxml',
      params_url: 'http://google.com',
      downloader: Tagfinder::Downloader,
      cli:        cli
    }
  end

  let(:result) do
    base_domain = 'https://devons-bucket-name.s3.devons-region.amazonaws.com/'
    {
      history: history,
      results_urls: [
        "#{base_domain}results/xxx/xxx-blah_chart.txt",
        "#{base_domain}results/xxx/xxx-blah_filter_log.txt",
        "#{base_domain}results/xxx/xxx-blah_filter_log2.txt",
        "#{base_domain}results/xxx/xxx-blah_filtered.mzxml",
        "#{base_domain}results/xxx/xxx-blah_massspec.csv",
        "#{base_domain}results/xxx/xxx-blah_summary.txt"
      ]
    }
  end
  let(:cli) { Sinatra::Base.development? ? Tagfinder::MacCLI.new : Tagfinder::UbuntuCLI.new }

  before do
    stub_const(
      'ENV',
      ENV.to_hash.merge(
        'AWS_ACCESS_KEY_ID'     => 'devons-access-key-id',
        'AWS_SECRET_ACCESS_KEY' => 'devons-secret-access-key',
        'AWS_BUCKET_REGION'     => 'devons-region',
        'AWS_S3_BUCKET'         => 'devons-bucket-name'
      )
    )

    # Suppress output to console
    $stdout.stub(:write)
    $stderr.stub(:write)

    allow_any_instance_of(Aws::S3::Object).to receive(:upload_file)
    allow(File).to receive(:file?).and_return(true)
    allow(SecureRandom).to receive(:uuid).and_return('xxx')
    allow(File).to receive(:write)
    allow(File).to receive(:delete)
  end

  it 'returns the expected result' do
    expect(Tagfinder::Execution.call(execution_opts)).to eql(history: history, error: '')
  end

  it 'deletes the results files after uploading to S3' do
    Tagfinder::Execution.call(execution_opts)

    expect(File).to have_received(:delete).with(
      Pathname.new('tmp').expand_path.join(*%w[data xxx-blah.mzxml]),
      Pathname.new('tmp').expand_path.join(*%w[params xxx-google.com]),
      *Tagfinder::Execution::ResultsUploader::RESULTS_SUFFIXES.map do |suffix|
        Pathname.new('tmp').expand_path.join(*%W[data xxx-blah_#{suffix}])
      end
    )
  end

  describe '#successful?' do
    it 'is false if the history contains an error' do
      skip
    end
  end
end
