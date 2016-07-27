module Tagfinder
  class Retrier
    include Procto.call, Concord.new(:error_type, :block, :options)

    def initialize(error_type, block, options = {})
      fail ArgumentError if options.keys.include?(:rescue)
      super(error_type, block, default_options.merge(options))
    end

    def call
      with_retries(options) { |retry_count| block.call(retry_count) }
    end

    private

    def handler
      proc do |e, attempt_number, total_delay|
        puts "Retry attempt ##{attempt_number} [#{total_delay} seconds have passed]. Saw:"
        puts "    #{e.message} (#{e.class})".gray
        puts "       #{e.backtrace.first}".gray
      end
    end

    def default_options
      {
        max_tries:          3,
        base_sleep_seconds: 0.1,
        max_sleep_seconds:  2,
        handler:            handler,
        rescue:             error_type
      }
    end

    class ENOENT < Retrier
      OPTIONS = {
        max_tries:          8,
        base_sleep_seconds: 4,
        max_sleep_seconds:  100,
      }

      def initialize(block)
        super(Errno::ENOENT, block, OPTIONS)
      end
    end
  end
end
