# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This is the base class for Panther errors. It provides an interface that all errors
      # expose, allowing them to be easily converted into HTTP responses.
      #
      # @author Alessandro Desantis
      class Base < StandardError
        # Converts the error into a hash suitable for JSON representation.
        #
        # This is a simple hash with the +error+, +message+ and +meta+ keys.
        #
        # @return [Hash]
        def as_json(_options)
          {
            error: status,
            message: message,
            meta: meta
          )
        end

        # Returns the HTTP status code to use for this error. By default, this is
        # +:internal_server_error+ (500 Internal Server Error).
        #
        # @return [Symbol]
        def status
          :internal_server_error
        end

        protected

        # Returns any metadata that should be attached to the basic error information.
        #
        # In the case of a validation error, for instance, this could be used to send the exact
        # errors that occured.
        #
        # @return [Hash]
        def meta
          {}
        end
      end
    end
  end
end
