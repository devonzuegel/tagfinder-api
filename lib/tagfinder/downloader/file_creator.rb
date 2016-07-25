module Tagfinder
  class Downloader
    class FileCreator
      extend AbstractClass

      include Procto.call, Concord.new(:filename, :content)

      DIR = Pathname.new('').expand_path

      def call
        File.write(full_path, content)
        full_path
      end

      private

      def full_path
        self.class::DIR.join(filename)
      end
    end

    class TmpFileCreator < FileCreator
      DIR = Pathname.new('tmp').expand_path

      def initialize(basename, content)
        super(with_random_prefix(basename), content)
      end

      private

      def with_random_prefix(basename)
        loop do
          with_prefix = "#{SecureRandom.uuid}-#{basename}"
          next if tmp_file_exists?(with_prefix)
          return with_prefix
        end
      end

      def tmp_file_exists?(basename)
        self.class::DIR.join(basename).file?
      end
    end

    class MzxmlFileCreator < TmpFileCreator
      DIR = DIR.join('data')
      EXT = '.mzxml'.freeze

      def initialize(basename, content)
        return super(basename, content) if mzxml_file?(basename)
        fail ArgumentError, "Data must be an .mzXML file, but given #{basename}"
      end

      private

      def mzxml_file?(basename)
        File.extname(basename).downcase.eql?(EXT)
      end
    end

    class ParamsFileCreator < TmpFileCreator
      DIR = DIR.join('params')
    end
  end
end
