# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      class Base < StandardError
        def as_json(_options)
          metadata.merge(
            error: status,
            message: message
          )
        end

        def status
          :internal_server_error
        end

        protected

        def metadata
          {}
        end
      end
    end
  end
end
