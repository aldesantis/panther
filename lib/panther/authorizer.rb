# frozen_string_literal: true
module Panther
  class Authorizer
    class << self
      def authorize(model:, params:, operation:)
        # FIXME: We call Validator.validate here to assign the params to the model/contract. Not
        # sure if the logic should be extracted or if we should avoid assigning the parameters.
        Validator.validate(model: model, params: params)
        model.errors.clear

        operation.policy_klass.new(
          model: model,
          user: params[:current_user]
        ).public_send("#{operation.operation_name}?")
      end

      def authorize!(model:, params:, operation:)
        fail(
          Operation::PolicyError,
          model: model,
          user: params[:current_user],
          action: operation.policy_klass
        ) unless authorize(
          model: model,
          params: params,
          operation: operation
        )
      end
    end
  end
end
