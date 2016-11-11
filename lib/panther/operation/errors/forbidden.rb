# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This error occurs when a user attempts an unauthorized operation.
      #
      # @author Alessandro Desantis
      class Forbidden < Base
        # @!attribute [r] resource
        #   @return [Object] the resource the operation was attempted on
        #
        # @!attribute [r] user
        #   @return [Object] the user who attempted the operation
        #
        # @!attribute [r] operation
        #   @return [Symbol] the operation that was attempted
        attr_reader :resource, :user, :operation

        def initialize(user: nil, operation: nil, resource: nil)
          @user = user
          @operation = operation&.to_sym
          @resource = resource

          super 'You are not authorized to perform this operation.'
        end

        # Returns +:forbidden+ (403 Forbidden).
        #
        # @return [Symbol]
        def status
          :forbidden
        end
      end
    end
  end
end
