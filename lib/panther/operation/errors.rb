# frozen_string_literal: true
module Panther
  module Operation
    class OperationError
      attr_reader :status

      def as_json(_options)
        metadata.merge(
          error: status,
          message: message
        )
      end

      protected

      def metadata
        {}
      end
    end

    class InvalidContractError < OperationError
      @status = :unprocessable_entity

      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super 'The contract for this operation was not respected'
      end

      protected

      def metadata
        { validation_errors: errors }
      end
    end

    class PolicyError < OperationError
      @status = :forbidden

      attr_reader :model, :user, :action

      def initialize(model:, user:, action:)
        @model = model
        @user = user
        @action = action

        super 'The current user is not authorized to perform the requested action'
      end
    end
  end
end
