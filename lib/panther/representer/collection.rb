# frozen_string_literal: true
module Panther
  module Representer
    module Collection
      def self.included(klass)
        klass.extend ClassMethods

        klass.class_eval <<-RUBY
          def data
            represented
          end

          collection(:data,
            exec_context: :decorator,
            decorator: resource_representer_name
          )
        RUBY
      end

      module ClassMethods
        def resource_representer_name
          name = "::#{self.name.to_s.split('::')[0..-2].join('::')}::Resource"
          name.constantize
        end
      end
    end
  end
end
