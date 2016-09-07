# frozen_string_literal: true
module Panther
  module Representer
    module Association
      class Binding
        attr_reader :association, :model, :includes

        def initialize(association:, model:, includes:)
          @association = association
          @model = model
          @includes = includes
        end

        def represent(params)
          value = value_for_representing(params)
          return nil unless value

          association.representer_klass.new(value).to_hash(user_options: {
            include: unnested_includes
          })
        end

        def represent_ids(_params)
          getter_name = if association.collection?
            "#{association.name.to_s.singularize}_ids"
          else
            "#{association.name}_id"
          end

          model.send(getter_name)
        end

        private

        def unnested_includes
          includes.select do |include_name|
            include_name.start_with?("#{association.name}__")
          end.map do |include_name|
            include_name.sub("#{association.name}__", '')
          end
        end

        def value_for_representing(params)
          value = model.send(association.name)

          if association.collection?
            Paginator.new(association).paginate(relation: value, params: params)
          else
            value
          end
        end
      end
    end
  end
end
