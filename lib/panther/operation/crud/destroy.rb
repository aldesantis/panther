# frozen_string_literal: true
module Panther
  module Operation
    # Default destroy operation
    #
    # This can be used as the starting point for destroy operations or standalone.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @abstract Subclass to implement a destroy operation
    #
    # @example A basic destroy operation
    #   module API
    #     module V1
    #       module User
    #         module Operation
    #           class Destroy < ::Panther::Operation::Destroy
    #           end
    #         end
    #       end
    #     end
    #   end
    class Destroy < Base
      # Finds a resource by the +id+ param, authorizes it and destroys it.
      #
      # Responds with the No Content HTTP status code and no resource.
      def call
        context.record = find_record

        authorize context.record

        context.record.destroy!

        respond_with status: :no_content
      end

      protected

      # Finds the resource. By default, uses the +id+ parameter.
      #
      # @return [ActiveRecord::Base]
      def find_record
        self.class.resource_model.find(params[:id])
      end
    end
  end
end
