# frozen_string_literal: true
module Panther
  # Authorizer
  #
  # The authorizer provides support for determining whether a user can perform an operation on a
  # certain resource by using Panther policies.
  #
  # The authorizer also takes into account the operation's parameters: for instance, a regular user
  # might be allowed to only set certain values for an attribute when updating a resource. For this
  # reason, the authorizer writes the parameters to the resource before querying the policy.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  # @see Policy::Base
  class Authorizer
    class << self
      # Authorizes an operation on the given resoruce
      #
      # @param resource [Contract::Base|ActiveRecord::Base] The resource to authorize
      # @param params [Hash] The parameters to use for authorization
      # @param operation [Operation::Base] The operation to authorize
      #
      # @return [Boolean] Whether the operation is authorized
      def authorize(resource:, params:, operation:)
        write_params resource, params

        operation.policy_klass.new(
          resource: resource,
          user: params[:current_user]
        ).public_send("#{operation.operation_name}?")
      end

      # Authorizes an operation and raises an error if authorization failed
      #
      # Runs {#authorize} with the provided parameters. If authorization fails, raises an
      # {Operation::Errors::Unauthorized} error.
      #
      # @see .authorize
      # @raise [Operation::Errors::Unauthorized] if the resource is invalid
      def authorize!(resource:, params:, operation:)
        fail(
          Operation::Errors::Unauthorized,
          resource: resource,
          user: params[:current_user],
          action: operation.policy_klass
        ) unless authorize(
          resource: resource,
          params: params,
          operation: operation
        )
      end

      private

      def write_params(resource, params)
        case resource
        when ActiveRecord::Base
          params.each_pair do |name, value|
            resource.try("#{name}=", value)
          end
        when Contract::Base
          resource.deserialize(params)
        end
      end
    end
  end
end
