# frozen_string_literal: true
module Panther
  module Representer
    module Association
      class Reflection
        attr_reader :name, :options

        def initialize(name, options = {})
          @name = name
          @options = default_options.merge(options)
          @namer = Namer.new(@options[:decorator_klass])
        end

        def representer_klass
          representer_module = "::#{@namer.namespace_module}::#{reflection.class_name}::Representer"

          if collection?
            "#{representer_module}::Collection"
          else
            "#{representer_module}::Resource"
          end.constantize
        end

        def model_klass
          reflection.class_name.constantize
        end

        delegate :collection?, to: :reflection

        def single?
          !collection?
        end

        private

        def default_options
          {
            expose_id: true,
            per_page: 10,
            per_page_param: "#{name}_per_page",
            page_param: "#{name}_page"
          }
        end

        def reflection
          @namer.resource_model.reflect_on_association(name)
        end
      end
    end
  end
end
