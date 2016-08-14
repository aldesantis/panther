module Panther
  module Operation
    module Errors
      class Unauthorized < Base
        attr_reader :model, :user, :action

        def initialize(model:, user:, action:)
          @model = model
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
