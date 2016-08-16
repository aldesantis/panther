# frozen_string_literal: true
module Panther
  # Validator
  #
  # The validator uses contracts to validate a resource.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  #
  # @see Contract::Base
  class Validator
    class << self
      # Validates a resource
      #
      # Does not write any attributes on the model/contract. Assignment should be handled by the
      # user or can be abstracted by using Panther's {Operation::Base#authorize_and_validate}.
      #
      # @param resource [Contract::Base|ActiveRecord::Base] The resource to validate
      #
      # @return [Boolean] Whether the resource is valid
      #
      # @example Validating a model outside of an operation
      #   class UpdateUser
      #     def self.run(user:, params:)
      #       user.assign_attributes(params)
      #       fail 'Invalid params' unless Panther::Validator.validate(resource: user)
      #
      #       # ...
      #     end
      #   end
      #
      # @example Validating a contract outside of an operation
      #   class UpdateUser
      #     def self.run(user:, params:)
      #       contract = API::V1::User::Contract::Update.new(user)
      #       contract.deserialize(params)
      #
      #       fail 'Invalid params' unless Panther::Validator.validate(resource: user)
      #
      #       # ...
      #     end
      #   end
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
      #
      # @raise [Operation::Errors::InvalidContract] if validation fails
      #
      # @example Validating outside of an operation
      #   class UpdateUser
      #     def self.run(user:, params:)
      #       user.assign_attributes(params)
      #       Panther::Validator.validate!(resource: user)
      #
      #       # ...
      #     end
      #   end
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
