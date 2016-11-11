# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a resource cannot be retrieved.
      #
      # @author Alessandro Desantis
      class NotFound < Base
        MESSAGE = 'The requested resource could not be found.'

        # Initializes the error.
        #
        # @param meta [Hash] any meta to attach to the error
        def initialize(meta = {})
          super MESSAGE, meta
        end

        # Returns +:not_found+ (404 Not Found).
        #
        # @return [Symbol]
        def status
          :not_found
        end
      end
    end
  end
end
