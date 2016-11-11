# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a user attempts to perform an operation for which a previous payment
      # is required.
      #
      # The Stripe API also uses this status code when invalid payment information (e.g. invalid
      # credit card information) is provided, but we suggest using {UnprocessableEntity} for that.
      #
      # @author Alessandro Desantis
      class PaymentRequired < Base
        MESSAGE = 'Payment is required to access this resource.'

        # Initializes the error.
        #
        # @param meta [Hash] any meta to attach to the error
        def initialize(meta = {})
          super MESSAGE, meta
        end

        # Returns +:payment_required+ (402 Payment Required).
        #
        # @return [Symbol]
        def status
          :payment_required
        end
      end
    end
  end
end
