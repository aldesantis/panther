# frozen_string_literal: true
module Panther
  module Operation
    # These hooks provide some useful behavior to be shared by all operations.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    module Hooks
      def self.included(klass)
        klass.class_eval do
          after :ensure_status
          around :handle_errors
          around :convert_errors
        end
      end

      # After hook: Ensures that a status code of +:ok+: is set if no status has been set for the
      # operation.
      def ensure_status
        context.status ||= :ok
      end

      # Around hook: Converts any Rails-specific errors raised in the operation into native Panther
      # errors.
      #
      # For instance, converts +ActiveRecord::RecordNotFound+ into
      # {Panther::Operation::Errors::NotFound}.
      #
      # @see Base#fail!
      def convert_errors(interactor)
        interactor.call
      rescue ActiveRecord::RecordNotFound
        fail! :not_found
      end

      # Around hook: Recovers from Panther errors by failing the operation's context with the
      # appropriate status code and the error as the resource.
      def handle_errors(interactor)
        interactor.call
      rescue Errors::Base => e
        context.fail!(resource: e, status: e.status)
      end
    end
  end
end
