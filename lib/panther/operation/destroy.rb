# frozen_string_literal: true
module Panther
  module Operation
    class Destroy < Base
      def run(params)
        record = self.class.resource_model.find(params[:id])

        authorize model: record, params: params

        record.destroy!
        after_destroy record

        head :no_content
      end

      private

      def after_destroy(record)
      end
    end
  end
end
