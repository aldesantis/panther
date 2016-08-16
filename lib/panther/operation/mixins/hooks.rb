# frozen_string_literal: true
module Panther
  module Operation
    module Hooks
      def self.included(klass)
        klass.class_eval do
          after :ensure_status
          around :handle_errors
          around :convert_errors
        end
      end

      def ensure_status
        context.status ||= :ok
      end

      def convert_errors(interactor)
        interactor.call
      rescue ActiveRecord::RecordNotFound
        fail! :not_found
      end

      def handle_errors(interactor)
        interactor.call
      rescue Errors::Base => e
        context.fail!(resource: e, status: e.status)
      end
    end
  end
end
