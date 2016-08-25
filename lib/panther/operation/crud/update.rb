# frozen_string_literal: true
module Panther
  module Operation
    # Default update operation
    #
    # This can be used as the starting point for update operations or standalone.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @abstract Subclass to implement a update operation
    #
    # @example A basic update operation
    #   module API
    #     module V1
    #       module User
    #         module Operation
    #           class Update < ::Panther::Operation::Update
    #           end
    #         end
    #       end
    #     end
    #   end
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
