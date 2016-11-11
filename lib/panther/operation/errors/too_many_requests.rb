# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a user sent too many requests in a set amount of time.
      #
      # @author Alessandro Desantis
      class TooManyRequests < Base
        MESSAGE = 'You are making too many requests at once.'

        # Initializes the error.
        #
        # @param meta [Hash] any meta to attach to the error
        def initialize(meta = {})
          super MESSAGE, meta
        end

        # Returns +:too_many_requests+ (429 Too Many Requests).
        #
        # @return [Symbol]
        def status
          :too_many_requests
        end
      end
    end
  end
end
