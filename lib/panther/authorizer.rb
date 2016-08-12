# frozen_string_literal: true
class Authorizer
  class << self
    def authorize(model:, params:, operation:)
      assign_params(model, params)

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

    private

    def assign_params(model, params)
      params.each_pair do |name, value|
        model.send("#{name}=", value) if model.respond_to?("#{name}=")
      end
    end
  end
end
