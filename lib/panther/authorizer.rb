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
  #
  # @see Policy::Base
  class Authorizer
    class << self
      # Authorizes an operation on the given resoruce
      #
      # @param resource [Contract::Base|ActiveRecord::Base] The resource to authorize
      # @param operation [Operation::Base] The operation to authorize
      # @param user [Object] The user to authorize
      #
      # @return [Boolean] Whether the operation is authorized
      #
      # @example Authorizing outside of an operation
      #   class BanUser
      #     def self.run(user:, current_user:)
      #       fail 'Unauthorized' unless Panther::Authorizer.authorize(
      #         resource: user,
      #         operation: API::V1::User::Operation::Create,
      #         user: current_user
      #       )
      #
      #       # ...
      #     end
      #   end
      def authorize(resource:, operation:, user:)
        operation.policy_klass.new(
          resource: resource,
          user: user
        ).public_send("#{operation.operation_name}?")
      end

      # Authorizes an operation and raises an error if authorization failed
      #
      # Runs {#authorize} with the provided parameters. If authorization fails, raises an
      # {Operation::Errors::Unauthorized} error.
      #
      # @see .authorize
      #
      # @raise [Operation::Errors::Unauthorized] if the resource is invalid
      #
      # @example Authorizing outside of an operation
      #   class BanUser
      #     def self.run(user:, current_user:)
      #       Panther::Authorizer.authorize!(
      #         resource: user,
      #         operation: API::V1::User::Operation::Create,
      #         user: current_user
      #       )
      #
      #       # ...
      #     end
      #   end
      def authorize!(resource:, operation:, user:)
        fail(
          Operation::Errors::Unauthorized,
          resource: resource,
          user: user,
          action: operation.policy_klass
        ) unless authorize(
          resource: resource,
          operation: operation,
          user: user
        )
      end
    end
  end
end
