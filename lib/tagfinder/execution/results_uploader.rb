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
        # []
      end

      private

      def starting_statuses
        # Hash[filepaths.map { |f| [f, { uploaded: false, removed: false }] }]
      end
    end

    class ResultFile
      include Concord.new(:local_filepath, :uploaded, :deleted)

      attr_reader :local_filepath

      def initialize(local_filepath)
        super(local_filepath, false, false)
      end

      def uploaded?
        uploaded
      end

      def deleted?
        deleted
      end

      def upload
        puts local_filepath
        S3Uploader.call(local_filepath)
      end
    end
  end
end
