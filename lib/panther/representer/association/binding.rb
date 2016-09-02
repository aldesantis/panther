# frozen_string_literal: true
module Panther
  module Representer
    module Association
      class Binding
        attr_reader :association, :model

        def initialize(association:, model:)
          @association = association
          @model = model
        end

        def represent(params)
          value = value_for_representing(params)
          return nil unless value

          association.representer_klass.new(value)
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

        def value_for_representing(params)
          value = model.send(association.name)

          if association.collection?
            Paginator.paginate(association: association, relation: value, params: params)
          else
            value
          end
        end
      end
    end
  end
end
