# frozen_string_literal: true
module Panther
  module Operation
    # Default show operation
    #
    # This can be used as the starting point for show operations or standalone.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @abstract Subclass to implement a show operation
    #
    # @example A basic show operation
    #   module API
    #     module V1
    #       module Post
    #         module Operation
    #           class Show < ::Panther::Operation::Show
    #           end
    #         end
    #       end
    #     end
    #   end
    class Show < Base
      # Finds the record by the +id+ parameter, authorizes it and exposes it.
      def call
        record = self.class.resource_model.find(params[:id])

        authorize record

        respond_with resource: self.class.representer_klass.new(record)
      end
    end
  end
end
