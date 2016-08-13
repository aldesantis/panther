# frozen_string_literal: true
module Panther
  module Operation
    class Show < Base
      def call
        record = self.class.resource_model.find(params[:id])

        authorize record

        respond_with resource: self.class.representer_klass.new(record)
      end
    end
  end
end
