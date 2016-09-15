# frozen_string_literal: true
module Panther
  # The namer calculates useful class/module names from a resource class.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  class Namer
    attr_reader :klass

    # Initializes the namer. Expects a class name like +Namespace::Resource::Module::Class+
    # (e.g. +API::V1::User::Operation::Create+) to work properly.
    #
    # @param [Class] the base class name
    def initialize(klass)
      @klass = klass
    end

    # Returns the namespace that encapsulates the resource.
    #
    # For instance, if the class name is +API::V1::User::Operation::Create+, returns
    # +API::V1+.
    #
    # @return [Module]
    def namespace_module
      klass.name.to_s.split('::')[0..-4].join('::').constantize
    end

    # Returns the module that encapsulates the resource.
    #
    # For instance, if the class name is +API::V1::User::Operation::Create+, returns
    # +API::V1::User+.
    #
    # @return [Module]
    def resource_module
      klass.name.to_s.split('::')[0..-3].join('::').constantize
    end

    # Returns the name of the resource.
    #
    # For instance, if the class name is +API::V1::User::Operation::Create+, returns
    # +user+.
    #
    # @return [String]
    def resource_name
      resource_module.to_s.demodulize
    end

    # Returns the model representing the resource.
    #
    # For instance, if the class name is +API::V1::User::Operation::Create+, returns
    # +::User+.
    #
    # @return [ActiveRecord::Base]
    def resource_model
      "::#{resource_name}".constantize
    end

    # Returns the resource representer class.
    #
    # For instance, if the class name is +API::V1::User::Operation::Create+, returns
    # +API::V1::User::Representer::Resource+.
    #
    # @return [Representer::Base]
    def representer_klass
      resource_module::Representer::Resource
    end

    # Returns the collection representer class.
    #
    # For instance, if the class name is +API::V1::User::Operation::Create+, returns
    # +API::V1::User::Representer::Collection+.
    #
    # @return [Representer::Base]
    def collection_representer_klass
      resource_module::Representer::Collection
    end

    # Returns the resource's policy class.
    #
    # For instance, if the class name is +API::V1::User::Operation::Create+, returns
    # +API::V1::User::Policy+.
    #
    # @return [Representer::Base]
    def policy_klass
      resource_module::Policy
    end
  end
end
