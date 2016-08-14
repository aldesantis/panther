module Panther
  module Operation
    module Errors
      class NotFound < Base
        def initialize
          super 'The requested resource could not be found'
        end

        def status
          :not_found
        end
      end
    end
  end
end
