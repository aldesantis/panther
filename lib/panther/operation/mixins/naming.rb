# frozen_string_literal: true
module Panther
  module Operation
    module Naming
      def self.included(klass)
        klass.extend ClassMethods
      end

      module ClassMethods
        def operation_name
          name.demodulize.underscore
        end

        def resource_module
          name.to_s.split('::')[0..-3].join('::').constantize
        end

        def resource_name
          resource_module.to_s.demodulize
        end

        def resource_model
          "::#{resource_name}".constantize
        end

        def representer_klass
          resource_module::Representer::Resource
        end

        def collection_representer_klass
          resource_module::Representer::Collection
        end

        def policy_klass
          resource_module::Policy
        end
      end
    end
  end
end
