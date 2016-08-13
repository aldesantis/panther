# frozen_string_literal: true
module Panther
  module Operation
    class Update < Base
      class << self
        def contract_klass
          resource_module::Contract::Update
        end
      end

      def call
        record = self.class.resource_model.find(params[:id])
        contract = self.class.contract_klass.new(record)

        authorize_and_validate contract

        contract.save

        respond_with resource: self.class.representer_klass.new(contract.model)
      end
    end
  end
end
