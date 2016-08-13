# frozen_string_literal: true
module Panther
  module Operation
    class Base
      include Interactor

      include Naming
      include Authorization
      include Validation

      def self.inherited(klass)
        klass.class_eval do
          include Hooks
        end
      end

      def call
        fail NotImplementedError
      end

      protected

      def params
        context.params
      end

      def authorize_and_validate(contract)
        authorize contract
        validate contract
      end

      def respond_with(status: nil, resource: nil)
        context.status = status
        context.resource = resource
      end

      def head(status)
        respond_with status: status
      end
    end
  end
end
