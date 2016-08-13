# frozen_string_literal: true
module Panther
  module Operation
    module Validation
      def validate(contract)
        Validator.validate!(
          model: contract,
          params: params
        )
      end
    end
  end
end
