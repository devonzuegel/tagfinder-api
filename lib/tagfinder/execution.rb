module Tagfinder
  class Execution
    include Procto.call, Memoizable, Anima.new(:data_url, :params_url, :downloader, :cli)

    RESULTS_SUFFIXES =
      %w[
        chart.txt
        filter_log.txt
        filter_log2.txt
        filtered.mzxml
        massspec.csv
        summary.txt
      ].freeze

    def call
      history = cli
        .tagfinder(data_filepath: data_filepath, params_filepath: params_filepath)
        .history
      # TODO: upload results to S3
      cleanup
      { history: history.to_s, results_urls: [] }
    end

    private

    def cleanup
      files_to_remove = [
        data_filepath,
        params_filepath,
        *results_uploader.filepaths
      ].reject(&:nil?)

      File.delete(*files_to_remove)
    end

    def results_uploader
      ResultsUploader.new(data_filepath)
    end

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
