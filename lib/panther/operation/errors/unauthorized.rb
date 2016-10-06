# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      class Unauthorized < Base
        attr_reader :resource, :user, :action

        def initialize(
          user:,
          action:,
          resource: nil,
          message: 'You are not authorized to perform this operation'
        )
          @resource = resource
          @user = user
          @action = action

          super message
        end

        def status
          :forbidden
        end
      end
    end
  end
end
