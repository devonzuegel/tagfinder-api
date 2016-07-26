module Tagfinder
  class KeyChecker
    include Procto.call, Concord.new(:keys)

    DEFAULT_KEYS  = %w[splat captures].freeze
    MINIMAL_KEYS  = DEFAULT_KEYS + %w[data_url key]
    OPTIONAL_KEYS = %w[params_url].freeze

    def call
      if minimal_keyset.subset?(user_keyset) && user_keyset.subset?(maximal_keyset)
        [true]
      else
        [false, error_msg]
      end
    end

    private

    def user_keyset
      Set.new(keys)
    end

    def minimal_keyset
      Set.new(MINIMAL_KEYS)
    end

    def maximal_keyset
      Set.new(MINIMAL_KEYS + OPTIONAL_KEYS)
    end

    def error_msg
      <<~HEREDOC
        Provided parameters don't match expected parameters:
          Provided: #{keys - DEFAULT_KEYS}
          Missing:  #{MINIMAL_KEYS - DEFAULT_KEYS - keys}

          Expected: #{MINIMAL_KEYS - DEFAULT_KEYS}
          Optional: #{OPTIONAL_KEYS}
      HEREDOC
    end
  end
end
