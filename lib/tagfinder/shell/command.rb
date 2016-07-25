module Tagfinder
  class Shell
    class Command
      extend AbstractClass

      include Procto.call(:to_s), Concord.new(:interpolated)

      def to_s
        format(self.class::CMD, interpolated).strip
      end
    end

    class Echo < Command
      CMD = 'echo "%<msg>s"'.freeze
    end

    class TagfinderMac < Command
      EXECUTABLE = Pathname.new('bin').join('tagfinder-mac')
      CMD        = "#{EXECUTABLE} %<data_filepath>s %<params_filepath>s".freeze
    end

    class TagfinderUbuntu < Command
      EXECUTABLE = Pathname.new('bin').join('tagfinder')
      CMD        = "#{EXECUTABLE} %<data_filepath>s %<params_filepath>s".freeze
    end
  end
end
