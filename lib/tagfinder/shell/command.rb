module Tagfinder
  class Shell
    class Command
      include Procto.call(:to_s), Concord.new(:interpolated)

      def to_s
        format(self.class::CMD, interpolated)
      end
    end
  end
end
