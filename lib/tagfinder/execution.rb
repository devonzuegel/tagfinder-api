module Tagfinder
  class Execution
    include Procto.call, Memoizable, Anima.new(:data_url, :params_url, :downloader, :cli)

    def call
      result = { history: history }

      if successful?
        result[:results_urls] = results_uploader.urls
      else
        result[:error] = stderrs.join("\n")
      end

      cleanup
      result
    end

    private

    def cleanup
      files_to_remove  = [data_filepath, params_filepath].reject(&:nil?)
      files_to_remove += results_uploader.filepaths if successful?
      File.delete(*files_to_remove)
    end

    def results_uploader
      ResultsUploader.new(data_filepath)
    end

    def successful?
      stderrs.join.empty?
    end

    def stderrs
      history.map { |output| output[:stderr] }
    end

    def history
      cli
        .tagfinder(data_filepath: data_filepath, params_filepath: params_filepath)
        .history.to_s
    end
    memoize :history

    def data_filepath
      download(data_url, Downloader::MzxmlFileCreator)
    end
    memoize :data_filepath

    def params_filepath
      download(params_url, Downloader::ParamsFileCreator) unless params_url.nil?
    end
    memoize :params_filepath

    def download(file_url, file_creator)
      downloader.call(
        url:          file_url,
        filename:     File.basename(file_url),
        file_creator: file_creator,
        connection:   Downloader::Connection
      )
    end
  end
end
