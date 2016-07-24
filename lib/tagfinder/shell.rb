module Tagfinder
  class Shell
    include Anima.new(:logger, :commands, :stdouts, :stderrs)

    attr_reader :commands, :stdouts, :stderrs

    def initialize(logger: false)
      super(logger: logger, commands: [], stdouts: [], stderrs: [])
    end

    def run(cmd)
      @commands += [cmd] if valid_command?(cmd)

      _, stdout, stderr = Open3.popen3(cmd)

      add_output(stdout.each_line.map { |x| x }.join)
      add_error(stderr.each_line.map { |x| x }.join)

      !errored?
    end

    def add_output(msg)
      @stdouts += [msg]
      print msg.light_green if logger
    end

    def add_error(msg)
      @stderrs += [msg]
      print msg.yellow if logger
    end

    private

    def errored?
      stderrs.join.downcase.include?('error')
    end

    def valid_command?(cmd)
      return true if cmd.end_with?(';')
      fail ArgumentError, 'Please end all commands with a semi-colon'
    end
  end
end