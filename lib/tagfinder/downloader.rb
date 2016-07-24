module Tagfinder
  class Downloader
    include Procto.call, Concord.new(:url, :local_path)

    def call
      file_body = Connection.call(Request.new(url))
      TmpFileCreator.call(local_path, file_body)
    end

    class TmpFileCreator
      TMP_DIR = Pathname.new('tmp').expand_path

      include Procto.call, Concord.new(:path, :content)

      def call
        construct_path
        File.write(full_path, content)
        full_path
      end

      private

      def full_path
        Pathname.new(TMP_DIR).join(path)
      end

      def construct_path
        dir_path = File.dirname(full_path)
        FileUtils.mkdir_p(dir_path) unless File.exist?(dir_path)
      end
    end

    class Request
      extend Forwardable
      include Concord.new(:url)

      def_delegator :url, :to_s

      def initialize(raw_url)
        super(validated_url(raw_url))
      end

      private

      def validated_url(url)
        uri = URI.parse(url)
        fail URI::InvalidURIError unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        uri
      end
    end

    class Connection
      include Procto.call, Concord.new(:request)

      private_class_method :new

      def call
        HTTP.get(request.to_s).body.to_s
      end
    end
  end
end
