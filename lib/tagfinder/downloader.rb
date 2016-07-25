module Tagfinder
  class Downloader
    include Procto.call, Anima.new(:url, :filename, :file_creator, :connection)

    def call
      file_creator.call(filename, file_body)
    end

    private

    def file_body
      connection.call(Request.new(url))
    end
  end
end
