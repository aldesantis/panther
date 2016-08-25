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
        record = self.class.resource_model.find(params[:id])

        authorize record

        record.destroy!

        respond_with status: :no_content
      end
    end
  end
end
