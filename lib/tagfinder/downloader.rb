module Tagfinder
  class Downloader
    include Procto.call, Concord.new(:url, :local_path)

    def call
      file_body = Connection.call(Request.new(url))
      TmpFileCreator.call(local_path, file_body)
    end
  end
end
