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
        puts handler_message(e, attempt_number, total_delay)
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

    def handler_message(e, attempt_num, total_delay)
      puts "\n#{Time.now} >".gray \
        "Retry attempt ##{attempt_num} [#{total_delay} seconds have passed]. Backtrace:\n".red \
        "  [#{e.class}] #{e.message}\n"  \
        "  #{e.backtrace.first}\n".gray
    end

    class ENOENT < Retrier
      OPTIONS = {
        max_tries:          2,
        base_sleep_seconds: 4,
        max_sleep_seconds:  30
      }.freeze

      def initialize(block)
        super(Errno::ENOENT, block, OPTIONS)
      end

      def handler_message(e, attempt_number, total_delay)
        msg = super(e, attempt_number, total_delay) + "  Directory contents:\n".gray
        Dir.entries(Pathname.new('tmp').join('data').expand_path).each do |entry|
          msg += "    #{entry}\n".gray
        end
        msg
      end
    end

    class Timeout < Retrier
      NUM_MINUTES = 200
      OPTIONS = {
        max_tries:          1,
        base_sleep_seconds: 1,
        max_sleep_seconds:  30
      }.freeze

      def initialize(block)
        super(::Timeout::Error, block, OPTIONS)
      end

      def call
        with_retries(options) do |retry_count|
          ::Timeout.timeout(60 * NUM_MINUTES) { block.call(retry_count) }
        end
      end
    end
  end
end
