RSpec.describe Tagfinder::Execution::S3Uploader do
  before do
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

  describe '.new' do
    it 'cannot be called' do
      expect { described_class.new }.to raise_error NoMethodError
    end
  end

  describe '.call' do
    context 'local file exists' do
      before { Aws::S3::Object.any_instance.stub(:upload_file) }

      it 'uploads the given file' do
        expect_any_instance_of(Aws::S3::Object).to receive(:upload_file)
        described_class.call(Pathname.new('run.rb').expand_path)
      end

      it 'returns the url of the uploaded file' do
        expect(described_class.call(Pathname.new('run.rb').expand_path))
          .to eql 'https://devons-bucket-name.s3.devons-region.amazonaws.com/results/xxx-run.rb'
      end
    end

    describe 'local file does not exist' do
      it 'raises an error if the given local file does not exist' do
        expect { described_class.call(Pathname.new('blah.txt')) }.to raise_error Errno::ENOENT
      end
    end
  end
end
