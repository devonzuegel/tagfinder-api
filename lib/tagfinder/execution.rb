module Tagfinder
  class Execution
    include Procto.call, Anima.new(:data_url, :config_url, :downloader, :cli)

    private_class_method :new

    def call
      downloader.call(data_url)
      downloader.call(config_url) unless config_url.nil?
      Cleanup.call()
    end

    class Cleanup
      include Procto.call(:clean)
    end

    class ListFiles
      CMD = 'ls -1 %<dir>s'.freeze
    end

    class CLI < CommandLine
      command :ls, ListFiles
    end
  end
end
