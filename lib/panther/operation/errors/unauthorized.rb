# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a user attempts to perform an operation without providing proper
      # authentication.
      #
      # @author Alessandro Desantis
      class Unauthorized < Base
        MESSAGE = 'You must be authenticated to perform this operation.'

        # Initializes the error.
        #
        # @param meta [Hash] any meta to attach to the error
        def initialize(meta = {})
          super MESSAGE, meta
        end

        # Returns +:unauthorized+ (401 Unauthorized).
        #
        # @return [Symbol]
        def status
          :unauthorized
        end
      end
    end
  end
end
