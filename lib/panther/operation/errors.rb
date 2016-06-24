# frozen_string_literal: true
module Panther
  module Operation
    class InvalidContractError < StandardError
      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super 'The contract for this operation was not respected'
      end

      def as_json(_options)
        {
          error: :unprocessable_entity,
          message: message,
          validation_errors: errors
        }
      end
    end

    class PolicyError < StandardError
      attr_reader :model, :user, :action

      def initialize(model:, user:, action:)
        @model = model
        @user = user
        @action = action

        super 'The current user is not authorized to perform the requested action'
      end

      def as_json(_options)
        {
          error: :forbidden,
          message: message
        }
      end
    end
  end
end
