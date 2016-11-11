# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a contract fails validation.
      #
      # @author Alessandro Desantis
      class InvalidContract < Base
        # @!attribute [r] errors
        #   @return [Hash] the errors that occurred
        attr_reader :errors

        # Initializes the error.
        #
        # @param errors [Hash] the errors that occurred
        def initialize(errors: nil)
          @errors = errors
          super 'The contract for this operation was not respected.'
        end

        # Returns +:unprocessable_entity+ (422 Unprocessable Entity).
        #
        # @return [Symbol]
        def status
          :unprocessable_entity
        end

        protected

        # Returns a hash with the provided errors in the +errors+ key.
        #
        # @return [Hash]
        def meta
          {}.tap do |m|
            m[:errors] = errors if errors
          end
        end
      end
    end
  end
end
