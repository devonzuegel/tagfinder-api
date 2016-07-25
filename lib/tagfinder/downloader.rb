module Tagfinder
  class Downloader
    include Procto.call, Concord.new(:url, :local_path, :file_creator)

    def initialize(url, local_path, file_creator: TmpFileCreator)
      super(url, local_path, file_creator)
    end

    def call
      file_creator.call(local_path, file_body)
    end

    private

    def file_body
      Connection.call(Request.new(url))
    end
  end
end
