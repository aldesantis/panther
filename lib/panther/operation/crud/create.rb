# frozen_string_literal: true
module Panther
  module Operation
    # Default create operation
    #
    # This can be used as the starting point for create operations or standalone.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @abstract Subclass and override {#build_resource} to implement a create operation
    #
    # @example A basic create operation
    #   module API
    #     module V1
    #       module User
    #         module Operation
    #           class Create < ::Panther::Operation::Create
    #             protected
    #
    #             def build_resource
    #               ::User.new
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    class Create < Base
      class << self
        # Returns the class of the create contract for this resource.
        #
        # If the operation's class is +API::V1::User::Operation::Create+, returns
        # +API::V1::User::Contract::Create+.
        #
        # @return [Contract::Base]
        def contract_klass
          resource_module::Contract::Create
        end
      end

      # Builds the resource, authorizes it, validates it and saves it.
      #
      # If the resource was persisted, responds with the Created HTTP status code and the resource.
      # If it was not persisted, responds with the Unprocessable Entity HTTP status code and the
      # validation errors.
      #
      # @see #build_resource
      def call
        context.record = build_resource
        context.contract = self.class.contract_klass.new(context.record)

        authorize_and_validate context.contract

        context.contract.save

        fail! :invalid_contract, errors: context.record.errors unless context.record.persisted?

        respond_with(
          resource: self.class.representer_klass.new(context.contract.model),
          status: :created
        )
      end

      protected

      # Returns a new resource for creation.
      #
      # This can be used for scoping the new resource or setting default attributes.
      #
      # @return [ActiveRecord::Base]
      #
      # @example Scoping the new resource
      #   module API
      #     module V1
      #       module Post
      #         module Operation
      #           class Create < ::Panther::Operation::Create
      #             protected
      #
      #             def build_resource
      #               ::Post.new(author: params[:current_user])
      #             end
      #           end
      #         end
      #       end
      #     end
      #   end
      def build_resource
        fail NotImplementedError
      end
    end
  end
end
