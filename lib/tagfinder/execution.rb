module Tagfinder
  class Execution
    include Procto.call, Memoizable, Anima.new(:data_url, :params_url, :downloader, :cli)

    def call
      history = cli
        .tagfinder(data_filepath: data_filepath, params_filepath: params_filepath)
        .history
      # TODO: upload results to S3
      cleanup
      history.to_a.map(&:to_s)
    end

    private

    def cleanup
      File.delete(*files_to_remove)
    end

    def results_files
      []
    end

    def files_to_remove
      [data_filepath, params_filepath, *results_files].reject(&:nil?)
    end

    def data_filepath
      downloader.call(
        url:          data_url,
        filename:     File.basename(data_url),
        file_creator: Downloader::MzxmlFileCreator,
        connection:   Downloader::Connection
      )
    end
    memoize :data_filepath

    def params_filepath
      return if params_url.nil?
      downloader.call(
        url:          params_url,
        filename:     File.basename(params_url),
        file_creator: Downloader::ParamsFileCreator,
        connection:   Downloader::Connection
      )
    end
    memoize :params_filepath
  end
end
