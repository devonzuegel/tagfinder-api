module Tagfinder
  class Execution
    class S3Uploader
      include Procto.call, Memoizable, Concord.new(:local_filepath, :s3_file)

      def initialize(local_filepath)
        s3_key = "results/#{SecureRandom.uuid}/#{File.basename(local_filepath)}"
        super(local_filepath, S3Bucket.new.object(s3_key))
      end

      private_class_method :new

      def call
        s3_file.upload_file(local_filepath, acl: 'public-read')
        s3_file.public_url
      end
    end

    class S3Bucket
      include Concord.new(:bucket)

      def initialize
        bucket = Aws::S3::Resource.new(
          credentials: credentials,
          region:      ENV['AWS_BUCKET_REGION']
        ).bucket(ENV['AWS_S3_BUCKET'])
        super(bucket)
      end

      def object(object_key)
        bucket.object(object_key)
      end

      private

      def credentials
        Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
      end
    end
    private_constant :S3Bucket
  end
end
