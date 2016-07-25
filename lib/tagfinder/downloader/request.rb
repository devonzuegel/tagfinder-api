module Tagfinder
  class Downloader
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
  end
end
