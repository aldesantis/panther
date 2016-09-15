# frozen_string_literal: true
module Panther
  # Controller mixin
  #
  # This module should be included in all controllers calling Panther operations. It provides
  # out of the box configuration for JSON APIs and helper methods for delegating to operations.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  module Controller
    # Included hook
    #
    # When including this module in a controller, +protect_from_forgery+ is called with the
    # +null_session+ and the controller is marked as responding to JSON.
    def self.included(klass)
      klass.class_eval do
        protect_from_forgery with: :null_session
        respond_to :json
      end

      klass.extend ClassMethods
    end

    module ClassMethods
      # Returns whether this controller supports an operation
      #
      # @param operation [String|Symbol] The operation to check
      #
      # @return [Boolean] Whether the operation is supported
      def supports?(operation)
        defined?(operation_klass(operation))
      end

      # Returns the module encapsulating the resource
      #
      # If the controller's name is +API::V1::UsersController+, the default module name will be
      # +API::V1::User+. Basically, the method appends {#resource_name} to the namespace.
      #
      # @return [Module] The resource module
      #
      # @see #resource_name
      def resource_module
        (name.to_s.split('::')[0..-2] << resource_name).join('::').constantize
      end

      # Returns the resource name
      #
      # If the controller's name is +API::V1::UsersController+, the default resource name will be
      # +User+.
      #
      # @return [String] The resource name
      def resource_name
        name.to_s.chomp('Controller').demodulize.singularize
      end

      # Returns the class handling an operation.
      #
      # If the controller's name is +API::V1::UsersController+, the default class of the +create+
      # operation will be +API::V1::User::Operation::Create+.
      #
      # @param operation [String|Symbol] Operation name
      #
      # @return [String] The operation class
      #
      # @see #resource_module
      def operation_klass(operation)
        "#{resource_module}::Operation::#{operation.to_s.camelcase}"
      end
    end

    %i(index show create update destroy).each do |operation|
      define_method operation do
        ensure_operation_exists operation
        run self.class.operation_klass(operation)
      end
    end

    protected

    # Runs the provided operation by calling {#call} on it and passing +operation_params+ as the
    # +params+ parameter.
    #
    # By default, +operation_params+ simply returns Rails' +params+, but it can be overridden to
    # provide additional context.
    #
    # Responds with the +status+ HTTP status of the context returned by the operation. If the
    # context returned by the operation has a +resource+ attribute, then the resource is also
    # rendered as JSON.
    #
    # @param klass [String|Operation::Base] The operation to run
    def run(klass)
      result = klass.to_s.constantize.call(params: operation_params)

      if result.resource
        render(
          json: result.resource.to_json(user_options: representer_options),
          status: result.status
        )
      else
        head result.status
      end
    end

    # Returns the params to pass to all operations.
    #
    # By default, this includes +params+ and +current_user+.
    #
    # @return [Hash]
    def operation_params
      params.merge(current_user: panther_user)
    end

    # Returns the options to pass to all representers. By default, contains +params+, +include+ and
    # +current_user+.
    #
    # @return [Hash]
    #
    # @see #panther_user
    def representer_options
      {
        params: params,
        include: params[:include].to_s.split(','),
        current_user: panther_user
      }
    end

    # Returns the current user. Should be overridden to return the user to use for all policies.
    #
    # @raise NotImplementedError
    def panther_user
      fail NotImplementedError
    end

    private

    def ensure_operation_exists(operation)
      return if self.class.supports?(operation)

      message = <<~ERROR.tr("\n", ' ').strip
        Expected #{operation} to be handled by #{operation_klass}, but the class is undefined
      ERROR

      fail NotImplementedError, message
    end
  end
end
