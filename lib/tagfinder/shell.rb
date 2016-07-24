require 'concord'
require 'anima'

module Tagfinder
  class Shell
    include Anima.new(:adapter, :history)

    def self.create(adapter)
      new(adapter: adapter, history: History.new([]))
    end

    def run(command)
      output = Output.coerce(*adapter.execute(command.to_s))

      with(history: history.add(command, output))
    end

    class Output
      include Anima.new(:stdout, :stderr, :status)

      def self.coerce(_, stdout, stderr, process)
        new(
          stdout: stdout.read,
          stderr: stderr.read,
          status: process.value
        )
      end
    end

    class History
      include Concord.new(:executions)

      def add(command, output)
        self.class.new(executions + [Execution.new(command, output)])
      end

      def to_a
        executions
      end

      class Execution
        include Concord::Public.new(:command, :output)
      end
      private_constant(:Execution)
    end
  end
end
