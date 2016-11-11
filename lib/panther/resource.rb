# frozen_string_literal: true
module Panther
  # A resource is anything in your API that can be operated on (e.g. users, posts, orders etc.).
  # It can expose a policy, operations, representers and contracts.
  #
  # This base class serves as a container for a resource's configurations and is an entry point to
  # all the other classes your resource exposes.
  #
  # @author Alessandro Desantis
  class Resource
    class << self
      # Returns the class of this resource's policy, whether it exists or not.
      #
      # @return [String]
      def policy_klass
        build_klass :policy
      end

      # Returns whether this resource exposes a policy.
      #
      # @return [Boolean]
      def policy?
        klass? policy_klass
      end

      # Returns the class of the given operation for this resource, whether it exists or not.
      #
      # @param [String|Symbol] operation
      #
      # @return [String]
      def operation_klass(operation)
        build_klass :operation, operation
      end

      # Returns whether this resource supports the given operation.
      #
      # @param [String|Symbol] operation
      #
      # @return [Boolean]
      def operation?(operation)
        klass? operation_klass(operation)
      end

      # Returns the class of the given representer for this resource, whether it exists or not.
      #
      # @param [String|Symbol] representer
      #
      # @return [String]
      def representer_klass(representer)
        build_klass :representer, representer
      end

      # Returns whether this resource supports the given representer.
      #
      # @param [String|Symbol] representer
      #
      # @return [Boolean]
      def representer?(representer)
        klass? representer_klass(representer)
      end

      # Returns the class of the given contract for this resource, whether it exists or not.
      #
      # @param [String|Symbol] contract
      #
      # @return [String]
      def contract_klass(contract)
        build_klass :contract, contract
      end

      # Returns whether this resource supports the given contract.
      #
      # @param [String|Symbol] contract
      #
      # @return [Boolean]
      def contract?(contract)
        klass? contract_klass(contract)
      end

      private

      def build_klass(*parts)
        [name, parts.map { |part| part.to_s.camelize }].flatten.join('::')
      end

      def klass?(klass)
        !!Object.const_get(klass)
      rescue NameError
        false
      end
    end
  end
end
