# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      class InvalidContract < Base
        attr_reader :errors

        def initialize(errors:)
          @errors = errors
          super 'The contract for this operation was not respected'
        end

        def status
          :unprocessable_entity
        end

        protected

        def metadata
          { validation_errors: errors }
        end
      end
    end
  end
end
