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
    end
  end
end
