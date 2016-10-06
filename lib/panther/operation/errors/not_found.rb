# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      class NotFound < Base
        def initialize(message: 'The requested resource could not be found')
          super message
        end

        def status
          :not_found
        end
      end
    end
  end
end
