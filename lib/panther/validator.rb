# frozen_string_literal: true
module Panther
  # Validator
  #
  # The validator uses contracts to validate a resource.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  # @see Contract::Base
  class Validator
    class << self
      # Validates a resource
      #
      # @param resource [Contract::Base|ActiveRecord::Base] The resource to validate
      #
      # @return [Boolean] Whether the resource is valid
      def validate(resource:)
        case resource
        when Contract::Base
          validate_contract(resource)
        when ActiveRecord::Base
          validate_model(resource)
        end
      end

      # Validates a resource and raises an error if it's invalid
      #
      # Calls {#validate} on the given resource and raises a {Operation::Errors::InvalidContract}
      # error if validation fails.
      #
      # @see .validate
      # @raise [Operation::Errors::InvalidContract] if validation fails
      def validate!(resource:)
        fail(
          Operation::Errors::InvalidContract,
          errors: resource.errors
        ) unless validate(resource: resource)
      end

      private

      def validate_contract(contract)
        contract.validate({})
      end

      def validate_model(model)
        model.validate
      end
    end
  end
end
