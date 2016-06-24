# frozen_string_literal: true
module Panther
  module Policy
    class Base
      attr_reader :user, :model

      def initialize(user:, model:)
        @user = user
        @model = model
      end
    end
  end
end
