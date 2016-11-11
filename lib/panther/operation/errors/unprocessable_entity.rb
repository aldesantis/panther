# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a contract fails validation.
      #
      # @author Alessandro Desantis
      class UnprocessableEntity < Base
        MESSAGE = 'Your request does not respect the contract for this operation.'

        # Initializes the error.
        #
        # @param meta [Hash] any meta to attach to the error
        def initialize(meta = {})
          super MESSAGE, meta
        end

        # Returns +:unprocessable_entity+ (422 Unprocessable Entity).
        #
        # @return [Symbol]
        def status
          :unprocessable_entity
        end
      end
    end
  end
end
