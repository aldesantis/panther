# frozen_string_literal: true
module Panther
  module Representer
    module Timestamped
      def self.included(klass)
        klass.class_eval <<-RUBY
          property :created_at, exec_context: :decorator
          property :updated_at, exec_context: :decorator

          def created_at
            represented.created_at.to_i
          end

          def updated_at
            represented.updated_at.to_i
          end
        RUBY
      end
    end
  end
end
