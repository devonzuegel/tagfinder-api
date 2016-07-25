module Tagfinder
  class Downloader
    class Connection
      include Procto.call, Concord.new(:request)

      private_class_method :new

      def call
        HTTP.get(request.to_s).body.to_s
      end
    end
  end
end
