# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      # This is the base class for Panther errors. It provides an interface that all errors
      # expose, allowing them to be easily converted into HTTP responses.
      #
      # @author Alessandro Desantis
      class Base < StandardError
        # @!attribute [r] meta
        #   @return [Hash] any meta to attach to the error
        attr_reader :meta

        # Initializes the error.
        #
        # @param message [String] the error message
        # @param meta [Hash] any meta to attach to the error
        def initialize(message, meta = {})
          @meta = meta
          super message
        end

        # Converts the error into a hash suitable for JSON representation.
        #
        # This is a simple hash with the +error+, +message+ and +meta+ keys.
        #
        # @return [Hash]
        def as_json(_options)
          {
            error: type,
            message: message,
            meta: meta
          }
        end

        # Returns the HTTP status code to use for this error.
        #
        # @return [Symbol]
        #
        # @raise [NotImplmentedError]
        def status
          fail NotImplementedError
        end

        # Returns a machine-readable error type. By default, returns {#status}.
        #
        # You might want to change this to something more specific: a 403 Forbidden error, for
        # instance, might have many different meanings and a client could use this field to decide
        # how to handle the error.
        #
        # @return [Symbol]
        def type
          status
        end
      end
    end
  end
end
