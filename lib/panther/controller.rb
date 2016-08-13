# frozen_string_literal: true
module Panther
  module Controller
    def self.included(klass) # rubocop:disable Metrics/MethodLength
      klass.class_eval <<-'RUBY'
        protect_from_forgery with: :null_session
        respond_to :json

        class << self
          @actions = []

          def supports?(action)
            @actions.include?(action.to_sym)
          end

          def resource_module
            (name.to_s.split('::')[0..-2] << resource_name)
              .join('::')
              .constantize
          end

          def resource_name
            name.to_s.chomp('Controller').demodulize.singularize
          end

          def operation_klass(operation)
            (
              resource_module.to_s << "::Operation::#{operation.to_s.camelcase}"
            ).constantize
          end

          protected

          def actions(*new_actions)
            @actions = new_actions.map(&:to_sym)
          end
        end

        %i(index show create update destroy).each do |action|
          define_method action do
            fail NotImplementedError unless self.class.supports?(action)
            run self.class.operation_klass(action)
          end
        end

        protected

        def run(klass)
          result = klass.call(params: operation_params)

          if result.resource
            render json: result.resource, status: result.status
          else
            head result.status
          end
        end

        private

        def operation_params
          params
        end
      RUBY
    end
  end
end
