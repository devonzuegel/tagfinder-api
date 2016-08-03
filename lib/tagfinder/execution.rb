module Tagfinder
  class Execution
    include Procto.call, Memoizable, Anima.new(:data_url, :params_url, :downloader, :cli)

    def call
      puts "\n#{Time.now} >".gray + "  Beginning execution with the following parameters:".blue
      puts "      - #{data_url}".white
      puts "      - #{params_url}".white

      result = { history: history }

      if successful?
        result[:results_urls] = results_uploader.urls
      else
        result[:error] = history.map { |output| output[:stderr] }.join("\n")
      end

      puts "\n#{Time.now} >".gray + "  Finished execution with the following parameters:".green
      puts "      - #{data_url}".white
      puts "      - #{params_url}".white
      ap result

      puts "\n#{Time.now} >".gray + "  Cleaning up execution with the following parameters:".yellow
      puts "      - #{data_url}".white
      puts "      - #{params_url}".white
      cleanup

      result
    end

    private

    def cleanup
      files_to_remove  = [data_filepath, params_filepath].reject(&:nil?)
      files_to_remove += results_uploader.filepaths if successful?

      puts "\n#{Time.now} >".gray + "  Deleting the following files:".blue
      files_to_remove.each { |f| puts "      - #{f}".white }

      File.delete(*files_to_remove.select { |fp| File.file?(fp) })
    end

    def results_uploader
      ResultsUploader.new(data_filepath)
    end

    def successful?
      history.map { |output| output[:status] }.reduce(&:|) == 0
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
