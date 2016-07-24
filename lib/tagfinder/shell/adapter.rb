require 'open3'

module Tagfinder
  class Shell
    class Adapter
      def execute(command)
        Open3.popen3(command)
      end
    end
  end
end
