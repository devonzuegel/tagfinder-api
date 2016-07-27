module Tagfinder
  class Execution
    class ResultsUploader
      include Concord.new(:data_filepath)

      RESULTS_SUFFIXES =
        %w[
          chart.txt
          filter_log.txt
          filter_log2.txt
          filtered.mzxml
          massspec.csv
          summary.txt
        ].freeze

      def filepaths
        RESULTS_SUFFIXES.map do |suffix|
          filename = "#{File.basename(data_filepath, '.*')}_#{suffix}"
          Pathname(File.dirname(data_filepath)).join(filename)
        end
      end

      def urls
        files.map(&:upload)
      end

      private

      def files
        filepaths.map { |fp| ResultFile.new(fp) }
      end
    end

    class ResultFile
      include Concord.new(:local_filepath, :uploaded), Memoizable

      attr_reader :local_filepath

      def initialize(local_filepath)
        super(local_filepath, false)
      end

      def uploaded?
        uploaded
      end

      def upload
        @uploaded = true
        with_retries(max_tries: 8, handler: enoent_handler, rescue: Errno::ENOENT) do
          S3Uploader.call(local_filepath)
        end
      end
      memoize :upload

      def enoent_handler
        proc do |exception, attempt_number, total_delay|
          puts "Handler saw a #{exception.class}; " \
               "Retry attempt ##{attempt_number}; " \
               "#{total_delay} seconds have passed"
        end
      end
    end
  end
end
