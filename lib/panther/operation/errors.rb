# frozen_string_literal: true
module Panther
  module Operation
    class OperationError < StandardError
      def as_json(_options)
        metadata.merge(
          error: status,
          message: message
        )
      end

      def status
        :internal_server_error
      end

      protected

      def metadata
        {}
      end
    end

    class InvalidContractError < OperationError
      attr_reader :errors

      def initialize(errors)
        @errors = errors
        super 'The contract for this operation was not respected'
      end

      def status
        :unprocessable_entity
      end

      protected

      def metadata
        { validation_errors: errors }
      end
    end

    class PolicyError < OperationError
      attr_reader :model, :user, :action

      def initialize(model:, user:, action:)
        @model = model
        @user = user
        @action = action

        super 'The current user is not authorized to perform the requested action'
      end

      def status
        :forbidden
      end
    end
  end
end
