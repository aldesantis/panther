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
        # Returns the class of the update contract for this resource.
        #
        # If the operation's class is +API::V1::User::Operation::Update+, returns
        # +API::V1::User::Contract::Update+.
        #
        # @return [Class]
        def contract_klass
          resource_module::Contract::Update
        end
      end

      # Finds the resource, authorizes it, validates it, then updates it with the provided
      # parameters.
      #
      # Responds with the resource if it was successfullyupdated.
      #
      # Otherwise, responds with 422 Unprocessable Entity and any validation errors.
      #
      # @see #find_record
      def call
        context.record = find_record
        context.contract = build_contract

        authorize_and_validate context.contract

        context.contract.save

        fail! :invalid_contract, errors: context.record.errors unless context.record.persisted?

        respond_with resource: self.class.representer_klass.new(context.contract.model)
      end

      protected

      # Finds the resource. By default, uses the +id+ parameter.
      #
      # @return [ActiveRecord::Base]
      def find_record
        self.class.resource_model.find(params[:id])
      end

      # Builds a contract for the new resource.
      #
      # @return [Contract::Base]
      def build_contract
        self.class.contract_klass.new(context.record)
      end
    end
  end
end
