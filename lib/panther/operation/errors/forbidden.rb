# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a user attempts an unauthorized operation.
      #
      # @author Alessandro Desantis
      class Forbidden < Base
        MESSAGE = 'You are not authorized to perform this operation.'

        # Initializes the error.
        #
        # @param meta [Hash] any meta to attach to the error
        def initialize(meta = {})
          super MESSAGE, meta
        end

        # Returns +:forbidden+ (403 Forbidden).
        #
        # @return [Symbol]
        def status
          :forbidden
        end
      end
    end
  end
end