# frozen_string_literal: true
module Panther
  module Operation
    # Naming mixin
    #
    # Provides some useful methods to retrieve class and module names. These are used in the
    # default CRUD operations.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    module Naming
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        # Returns the name of this operation.
        #
        # For instance, if the operation class is +API::V1::User::Operation::Create+, returns
        # +create+.
        #
        # @return [String]
        def operation_name
          name.demodulize.underscore
        end

        # Returns the module that encapsulates the resource.
        #
        # For instance, if the operation's class is +API::V1::User::Operation::Create+, returns
        # +API::V1::User+.
        #
        # @return [Module]
        def resource_module
          name.to_s.split('::')[0..-3].join('::').constantize
        end

        # Returns the name of the resource.
        #
        # For instance, if the operation's class is +API::V1::User::Operation::Create+, returns
        # +user+.
        #
        # @return [String]
        def resource_name
          resource_module.to_s.demodulize
        end

        # Returns the model representing the resource.
        #
        # For instance, if the operation's class is +API::V1::User::Operation::Create+, returns
        # +::User+.
        #
        # @return [ActiveRecord::Base]
        def resource_model
          "::#{resource_name}".constantize
        end

        # Returns the resource representer class.
        #
        # For instance, if the operation's class is +API::V1::User::Operation::Create+, returns
        # +API::V1::User::Representer::Resource+.
        #
        # @return [Representer::Base]
        def representer_klass
          resource_module::Representer::Resource
        end

        # Returns the collection representer class.
        #
        # For instance, if the operation's class is +API::V1::User::Operation::Create+, returns
        # +API::V1::User::Representer::Collection+.
        #
        # @return [Representer::Base]
        def collection_representer_klass
          resource_module::Representer::Collection
        end

        # Returns the resource's policy class.
        #
        # For instance, if the operation's class is +API::V1::User::Operation::Create+, returns
        # +API::V1::User::Policy+.
        #
        # @return [Representer::Base]
        def policy_klass
          resource_module::Policy
        end
      end
    end
  end
end
