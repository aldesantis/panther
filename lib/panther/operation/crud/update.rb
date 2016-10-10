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
        build_contract

        authorize_and_validate context.contract
        context.contract.save

        respond_with resource: self.class.representer_klass.new(context.contract.model)
      end

      protected

      def find_record
        context.record ||= self.class.resource_model.find(params[:id])
      end

      def build_contract
        context.contract ||= self.class.contract_klass.new(find_record)
      end
    end
  end
end
