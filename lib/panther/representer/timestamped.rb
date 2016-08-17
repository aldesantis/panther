# frozen_string_literal: true
module Panther
  module Representer
    module Timestamped
      def self.included(klass)
        klass.class_eval do
          property :created_at, exec_context: :decorator, if: -> (_) { respond_to?(:created_at) }
          property :updated_at, exec_context: :decorator, if: -> (_) { respond_to?(:updated_at) }
        end
      end

      def created_at
        represented.created_at.to_i
      end

      def updated_at
        represented.updated_at.to_i
      end
    end
  end
end
