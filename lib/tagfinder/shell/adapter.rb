require 'open3'

module Tagfinder
  class Shell
    class Adapter
      def execute(command)
        stdouts = ''
        stderrs = ''

        Open3.popen3(command) do |_, stdout, stderr, process|
          puts 'stdout:'.gray
          stdout.each do |line|
            stdouts << line
            puts line.blue
          end

          puts 'stderr:'.gray
          stderr.each do |line|
            stderrs << line
            puts line.magenta
          end

          [stdouts, stderrs, process]
        end
      end
    end
  end
end
