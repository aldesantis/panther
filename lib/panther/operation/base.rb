# frozen_string_literal: true
module Panther
  module Operation
    # An operation executes a specific task on a resource.
    #
    # Operations are interactors and inherit their behavior: they are stateless for the user, but
    # they have a context which can succeed or fail.
    #
    # Operations always expose a +status+ attribute in their output context, which is a symbol
    # representing the HTTP status code to respond with. They may also optionally expose a
    # +resource+ attribute, which is an object responding to +#to_json+ to be rendered.
    #
    # Operations also support before, around and after callbacks.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @abstract Subclass and override {#call} to implement an operation
    #
    # @see https://github.com/collectiveidea/interactor Interactor
    #
    # @example An example operation
    #   module API
    #     module V1
    #       module User
    #         module Operation
    #           class Create < ::Panther::Operation::Base
    #             def call
    #               user = ::User.new(context.params)
    #
    #               if user.save
    #                 respond_with resource: user
    #               else
    #                 respond_with resource: user.errors, status: :unprocessable_entity
    #               end
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    class Base
      include Interactor

      include Naming
      include Authorization
      include Validation

      class << self
        def inherited(klass)
          klass.class_eval do
            include Hooks
          end
        end

        # Returns the name of this operation.
        #
        # For instance, if the operation class is +API::V1::User::Operation::Create+, returns
        # +create+.
        #
        # @return [String]
        def operation_name
          name.demodulize.underscore
        end
      end

      # Executes the operation
      #
      # @see https://github.com/collectiveidea/interactor Interactor
      def call
        fail NotImplementedError
      end

      protected

      # Returns the operation's params
      #
      # This is just a shortcut for retrieving +context.params+.
      #
      # @return [Hash]
      def params
        context.params
      end

      # Writes the parameters to the given resource, then authorizes it and validates it.
      #
      # @param [ActiveRecord::Base|Contract::Base] The resource to authorize and validate
      def authorize_and_validate(resource)
        write_params_to resource

        authorize resource
        validate resource
      end

      # Responds with the given status code and resource.
      #
      # This is just a shortcut for setting +context.status+ and +context.resource+.
      #
      # @param status [Symbol] The status to set
      # @param resource [ActiveRecord::Base|Representer::Base] The resource to set
      def respond_with(status: nil, resource: nil)
        context.status = status
        context.resource = resource
      end

      # Responds with the given status code.
      #
      # This is just a shortcut for setting +context.status+. Under the hood, it calls
      # {#respond_with} with the given status code and no resource.
      #
      # @param status [Symbol] The status to set
      def head(status)
        respond_with status: status
      end

      # Raises the given Panther error. Passes any other arguments to the error.
      #
      # @param error [Symbol] The error to raise
      #
      # @raise [Panther::Operation::Errors::Base] The provided Panther error
      #
      # @example Raising an authorization error
      #   # Raises Panther::Operation::Errors::Unauthorized with the provided arguments
      #   fail! :unauthorized, resource: resource, user: current_user, action: :create
      def fail!(error, *args)
        klass_name = "::Panther::Operation::Errors::#{error.to_s.camelize}"
        fail klass_name.constantize, *args
      end

      private

      def write_params_to(resource)
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
