# frozen_string_literal: true
module Panther
  module Operation
    module Authorization
      def authorize(model)
        Authorizer.authorize!(
          model: model,
          params: params,
          operation: self.class
        )
      end
    end
  end
end
