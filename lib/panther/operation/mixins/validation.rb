# frozen_string_literal: true
module Panther
  module Operation
    # Validation mixin
    #
    # This module adds support for the {Validator} to a class.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    # @see Validator
    module Validation
      # Validates a resource
      #
      # Calls {Validator.validate!} with the given resource. Expects a #params method to be defined
      # on the class.
      #
      # @see Validator.validate!
      def validate(resource)
        Validator.validate! resource: resource
      end
    end
  end
end
