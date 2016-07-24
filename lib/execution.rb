module Tagfinder
  class Execution
    include Procto.call

    TMP_DIR           = File.join(%w[. tmp])
    UBUNTU_EXECUTABLE = File.join(%w[. bin tagfinder])
    MAC_EXECUTABLE    = File.join(%w[. bin tagfinder-mac])

    include Concord.new(:data_file_url, :config_file_url, :dir)

    def initialize(data_file_url, config_file_url)
      super(data_file_url, config_file_url, generate_dir)
    end

    def call
      prepare_inputs
      run_tagfinder
      cleanup
      {
        commands: shell.commands,
        outputs:  shell.stdouts,
        errors:   shell.stderrs,
        dir:      dir
      }
    end

    private

    def prepare_inputs
      download(data_file_url, local_data_filepath)

      if used_default_config?
        shell.add_output('No config file specified. Continuing...')
      else
        download(config_file_url, local_config_filepath)
      end
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

    def used_default_config?
      config_file_url.nil?
    end

    def download(file_url, local_filepath)
      shell.add_output("Downloading '#{file_url}' to '#{local_filepath}'...")
      shell.run("wget -O #{local_filepath} #{file_url};")
    end

    def run_tagfinder
      shell.run(command)
    end

    def command
      if used_default_config?
        "#{executable} #{local_data_filepath};"
      else
        "#{executable} #{local_data_filepath} #{local_config_filepath};"
      end
    end

    def executable
      Sinatra::Base.production? ? UBUNTU_EXECUTABLE : MAC_EXECUTABLE
    end

    def cleanup
      shell.run("rm -rf #{dir};")
    end

    def shell
      @shell ||= Tagfinder::Shell.new(logger: true)
    end
  end
end
