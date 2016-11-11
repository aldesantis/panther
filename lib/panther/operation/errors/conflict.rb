# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a user attempts to perform an operation that generated or would
      # generate a data conflict.
      #
      # It can be used as a response when a unique index constraint is violated.
      #
      # @author Alessandro Desantis
      class Conflict < Base
        MESSAGE = 'This request cannot be processed due to data conflict.'

        # Initializes the error.
        #
        # @param meta [Hash] any meta to attach to the error
        def initialize(meta = {})
          super MESSAGE, meta
        end

        # Returns +:conflict+ (409 Conflict).
        #
        # @return [Symbol]
        def status
          :conflict
        end
      end
    end
  end
end
