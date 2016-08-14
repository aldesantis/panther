# frozen_string_literal: true
module Panther
  module Operation
    # Authorization mixin
    #
    # This mixin adds support for the {Authorizer} to a class.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    # @see Authorizer
    module Authorization
      # Authorizes a resource
      #
      # Calls {Autorizer.authorize!} with the given resource. Expects a #params method to be defined
      # on the class and the class to include the {Naming} mixin.
      #
      # @see Authorizer.authorize!
      # @see Naming
      def authorize(resource)
        Authorizer.authorize!(
          resource: resource,
          params: params,
          operation: self.class
        )
      end
    end
  end
end
