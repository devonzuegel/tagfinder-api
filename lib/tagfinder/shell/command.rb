module Tagfinder
  class Shell
    class Command
      extend AbstractClass

      include Procto.call(:to_s), Concord.new(:interpolation)

      def to_s
        format(self.class::CMD, interpolation).strip
      end
    end

    class Echo < Command
      CMD = 'echo "%<msg>s"'.freeze
    end

    class TagfinderMac < Command
      EXECUTABLE = Pathname.new('.').join('bin', 'tagfinder-mac')
      CMD        = "nice -n %<priority>s #{EXECUTABLE} %<data_filepath>s %<params_filepath>s".freeze

      def initialize(data_filepath:, params_filepath: nil, priority: 0)
        super(
          data_filepath:   data_filepath,
          params_filepath: params_filepath,
          priority:        priority.to_s
        )
      end
    end

    class TagfinderUbuntu < Command
      EXECUTABLE = Pathname.new('.').join('bin', 'tagfinder')
      CMD        = "sudo nice -n %<priority>s #{EXECUTABLE} %<data_filepath>s %<params_filepath>s".freeze

      def initialize(data_filepath:, params_filepath: nil, priority: 0)
        super(
          data_filepath:   data_filepath,
          params_filepath: params_filepath,
          priority:        priority.to_s
        )
      end
    end
  end
end
