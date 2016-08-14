# frozen_string_literal: true
module Panther
  class Authorizer
    class << self
      def authorize(model:, params:, operation:)
        operation.policy_klass.new(
          model: model,
          user: params[:current_user]
        ).public_send("#{operation.operation_name}?")
      end

      def authorize!(model:, params:, operation:)
        fail(
          Operation::Errors::Unauthorized,
          model: model,
          user: params[:current_user],
          action: operation.policy_klass
        ) unless authorize(
          model: model,
          params: params,
          operation: operation
        )
      end

      private

      def assign_params(model, params)
        case model
        when ActiveRecord::Base
          params.each_pair do |name, value|
            model.try("#{name}=", value)
          end
        when Contract::Base
          model.deserialize(params)
        end
      end
    end
  end
end
