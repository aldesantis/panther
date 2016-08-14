# frozen_string_literal: true
module Panther
  module Policy
    class Base
      attr_reader :user, :resource

      def initialize(user:, resource:)
        @user = user
        @resource = resource
      end
    end
  end
end
