# frozen_string_literal: true
module Panther
  module Operation
    class Destroy < Base
      def run(params)
        record = self.class.resource_model.find(params[:id])

        authorize model: record, params: params

        record.destroy!

        head :no_content
      end
    end
  end
end
