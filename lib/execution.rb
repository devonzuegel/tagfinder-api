module Tagfinder
  class Execution
    include Procto.call

    TMP_DIR = File.join(%w[. tmp])

    include Concord.new(:data_file_url, :config_file_url, :dir)

    def initialize(data_file_url, config_file_url)
      super(data_file_url, config_file_url, generate_dir)
    end

    def call
      prepare_inputs
      cleanup
      {
        outputs: shell.stdouts,
        errors:  shell.stderrs,
        dir:     dir
      }
      # sleep 3
    end

    private

    def cleanup
      shell.run("rm -rf #{dir};")
    end

    def prepare_inputs
      shell.run("wget -O #{local_data_filepath} #{data_file_url};")
      return if config_file_url.nil?
      shell.run("wget -O #{local_config_filepath} #{config_file_url};")
    end

    def shell
      @shell ||= Tagfinder::Shell.new(logger: true)
    end

    def local_config_filepath
      return nil if config_file_url.nil?
      local_filepath(config_file_url, 'config')
    end

    def local_data_filepath
      local_filepath(data_file_url, 'data')
    end

    def local_filepath(web_url, subdir)
      subdir_path = File.join(%W[. #{dir} #{subdir}])
      filepath    = File.join(%W[. #{dir} #{subdir} #{File.basename(web_url)}])
      Dir.mkdir(subdir_path) unless File.exist?(subdir_path)
      filepath
    end

    def generate_dir
      Dir.mkdir(TMP_DIR) unless File.exist?(TMP_DIR)

      loop do
        dirname = File.join(%W[#{TMP_DIR} #{SecureRandom.uuid}])
        next if File.exist?(dirname)
        Dir.mkdir(dirname)
        return dirname
      end
    end
  end
end