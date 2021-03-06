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
          scoring.txt
          summary.txt
        ].freeze

      def filepaths
        RESULTS_SUFFIXES.map do |suffix|
          filename = "#{File.basename(data_filepath, '.*')}_#{suffix}"
          Pathname(File.dirname(data_filepath)).join(filename)
        end
      end

      def urls
        files.select { |fp| File.file?(fp.local_filepath) }.map(&:upload)
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
        Retrier::ENOENT.call(proc { S3Uploader.call(local_filepath) })
      end
      memoize :upload
    end
  end
end
