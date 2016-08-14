RSpec.describe Tagfinder::Execution::ResultsUploader do
  let(:dir)              { Pathname.new('dir') }
  let(:data_filepath)    { dir.join('datafile.txt') }
  let(:results_uploader) { described_class.new(data_filepath) }

  before do
    allow_any_instance_of(Aws::S3::Object).to receive(:upload_file)
    allow(File).to receive(:file?).and_return(true)
    allow(SecureRandom).to receive(:uuid).and_return('xxx')
    stub_const(
      'ENV',
      ENV.to_hash.merge(
        'AWS_ACCESS_KEY_ID'     => 'devons-access-key-id',
        'AWS_SECRET_ACCESS_KEY' => 'devons-secret-access-key',
        'AWS_BUCKET_REGION'     => 'devons-region',
        'AWS_S3_BUCKET'         => 'devons-bucket-name'
      )
    )
  end

  describe '#filenames' do
    it 'returns local filepaths of results associated with :data_filepath' do
      expect(results_uploader.filepaths).to eql [
        dir.join('datafile_chart.txt'),
        dir.join('datafile_filter_log.txt'),
        dir.join('datafile_filter_log2.txt'),
        dir.join('datafile_filtered.mzxml'),
        dir.join('datafile_massspec.csv'),
        dir.join('datafile_scoring.txt'),
        dir.join('datafile_summary.txt')
      ]
    end
  end

  describe '#urls' do
    it 'returns results urls once results files have been uploaded' do
      base_domain = 'https://devons-bucket-name.s3.devons-region.amazonaws.com/'
      expect(results_uploader.urls).to eql [
        "#{base_domain}results/xxx/datafile_chart.txt",
        "#{base_domain}results/xxx/datafile_filter_log.txt",
        "#{base_domain}results/xxx/datafile_filter_log2.txt",
        "#{base_domain}results/xxx/datafile_filtered.mzxml",
        "#{base_domain}results/xxx/datafile_massspec.csv",
        "#{base_domain}results/xxx/datafile_scoring.txt",
        "#{base_domain}results/xxx/datafile_summary.txt"
      ]
    end
  end
end

RSpec.describe Tagfinder::Execution::ResultFile do
  let(:result_file) { described_class.new(Pathname.new('dir').join('file.txt')) }

  describe '.new' do
    it 'is initially not uploaded' do
      expect(result_file.uploaded?).to eql false
    end
  end

  describe '#local_filepath' do
    it 'returns the local filepath' do
      expect(result_file.local_filepath).to eql Pathname.new('dir').join('file.txt')
    end
  end

  describe '#upload' do
    before do
      allow_any_instance_of(Aws::S3::Object).to receive(:upload_file)
      allow(SecureRandom).to receive(:uuid).and_return('xxx')
      stub_const(
        'ENV',
        ENV.to_hash.merge(
          'AWS_ACCESS_KEY_ID'     => 'devons-access-key-id',
          'AWS_SECRET_ACCESS_KEY' => 'devons-secret-access-key',
          'AWS_BUCKET_REGION'     => 'devons-region',
          'AWS_S3_BUCKET'         => 'devons-bucket-name'
        )
      )
    end

    it 'uploads the local file and returns the upload url' do
      expect { result_file.upload }
        .to change { result_file.uploaded? }
        .from(false).to(true)
    end

    it 'uploads the local file and returns the upload url' do
      expect(result_file.upload)
        .to eql 'https://devons-bucket-name.s3.devons-region.amazonaws.com/results/xxx/file.txt'
    end
  end
end
