# frozen_string_literal: true
module Panther
  module Operation
    class Show < Base
      def run(params)
        record = self.class.resource_model.find(params[:id])

        authorize model: record, params: params

        self.class.representer_klass.new(record)
      end
    end
  end
end
