module Tagfinder
  class CommandLine
    extend Forwardable
    include Concord.new(:shell)

    def self.command(method_name, command_class)
      define_method(method_name) do |*args|
        run(command_class.call(*args))
      end
    end

    def_delegator :shell, :history

    private

    def run(command)
      self.class.new(shell.run(command))
    end
  end
end
