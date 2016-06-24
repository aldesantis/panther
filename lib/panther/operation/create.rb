# frozen_string_literal: true
module Panther
  module Operation
    class Create < Base
      class << self
        def contract_klass
          resource_module::Contract::Create
        end
      end

      def run(params)
        record = build_resource(params)
        contract = self.class.contract_klass.new(record)

        authorize_and_validate contract: contract, params: params

        contract.save

        self.class.representer_klass.new(contract.model)
      end

      private

      def build_resource(_params)
        fail NotImplementedError
      end
    end
  end
end
