# frozen_string_literal: true
module Panther
  module Operation
    module Errors
      class Unauthorized < Base
        attr_reader :resource, :user, :action

        def initialize(resource:, user:, action:)
          @resource = resource
          @user = user
          @action = action

          super 'The current user is not authorized to perform the requested action'
        end

        def status
          :forbidden
        end
      end
    end
  end
end
