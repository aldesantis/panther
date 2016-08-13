# frozen_string_literal: true
module Panther
  module Operation
    class Destroy < Base
      def call
        record = self.class.resource_model.find(params[:id])

        authorize record

        record.destroy!

        respond_with status: :no_content
      end
    end
  end
end
