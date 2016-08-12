# frozen_string_literal: true
class Validator
  class << self
    def validate(model:, params:)
      case model
      when Contract::Base
        validate_contract(model, params)
      when ActiveRecord::Base
        validate_model(model, params)
      end
    end

    def validate!(model:, params:)
      fail(
        Operation::InvalidContractError,
        model.errors
      ) unless validate(model: model, params: params)
    end

    private

    def validate_contract(contract, params)
      contract.validate(params)
    end

    def validate_model(model, params)
      assign_params(model, params)
      model.validate
    end

    def assign_params(model, params)
      params.each_pair do |name, value|
        model.send("#{name}=", value) if model.respond_to?("#{name}=")
      end
    end
  end
end
