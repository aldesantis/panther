# frozen_string_literal: true
module Panther
  module Operation
    module Hooks
      def self.included(klass)
        klass.class_eval do
          after :ensure_status
          around :handle_errors
        end
      end

      def ensure_status
        context.status ||= :ok
      end

      def handle_errors(interactor)
        interactor.call
      rescue Errors::Base => e
        context.fail!(resource: e, status: e.status)
      end
    end
  end
end
