module Panther
  module Controller
    def self.included(klass)
      klass.class_eval <<-RUBY
        protect_from_forgery with: :null_session
        respond_to :json

        protected

        def run(klass)
          begin
            result = klass.new.run(operation_params)
          rescue Panther::Operation::InvalidContractError => e
            render(json: e, status: :unprocessable_entity) and return
          rescue Panther::Operation::PolicyError => e
            render(json: e, status: :forbidden) and return
          end

          result.is_a?(Symbol) ? head(result) : render(json: result)
        end

        private

        def operation_params
          params
        end
      RUBY
    end
  end
end
