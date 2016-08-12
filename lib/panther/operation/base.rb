# frozen_string_literal: true
module Panther
  module Operation
    class Base
      include Hooks

      define_hooks :before_run, :after_run

      class << self
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

        def run(params)
          instance = new

          instance.run_hook :before_run, params
          result = instance.run params
          instance.run_hook :after_run, params, result

          result
        end
      end

      def run(_params)
        fail NotImplementedError
      end

      protected

      def authorize(model:, params:)
        Authorizer.authorize!(
          model: model,
          params: params,
          operation: self.class
        )
      end

      def validate(contract:, params:)
        Validator.validate!(
          model: contract,
          params: params
        )
      end

      def authorize_and_validate(contract:, params:)
        authorize model: contract, params: params
        validate contract: contract, params: params
      end

      def head(status)
        status.to_sym # Yep. Not much magic to it.
      end
    end
  end
end
