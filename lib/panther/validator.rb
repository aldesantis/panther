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
      # @param params [Hash] The parameters to use for validation
      #
      # @return [Boolean] Whether the resource is valid
      def validate(resource:, params:)
        case resource
        when Contract::Base
          validate_contract(resource, params)
        when ActiveRecord::Base
          validate_model(resource, params)
        end
      end


      # Validates a resource and raises an error if it's invalid
      #
      # Calls {#validate} on the given resource and raises a {Operation::Errors::InvalidContract}
      # error if validation fails.
      #
      # @see .validate
      # @raise [Operation::Errors::InvalidContract] if validation fails
      def validate!(resource:, params:)
        fail(
          Operation::Errors::InvalidContract,
          errors: resource.errors
        ) unless validate(resource: resource, params: params)
      end

      private

      def validate_contract(contract, params)
        contract.validate(params)
      end

      def validate_model(model, params)
        params.each_pair do |name, value|
          model.try("#{name}=", value)
        end

        model.validate
      end
    end
  end
end
