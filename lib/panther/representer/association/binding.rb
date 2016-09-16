# frozen_string_literal: true
module Panther
  module Representer
    module Association
      # Binds an association definition to a specific record/user_options pair and returns the
      # actual values to expose to API consumers.
      #
      # @author Alessandro Desantis <desa.alessandro@gmail.com>
      class Binding
        # @!attribute [r] association
        #   @return [Reflection] the association we bind to
        #
        # @!attribute [r] model
        #   @return [ActiveRecord::Base] the specific record we bind to
        #
        # @!attribute [r] user_options
        #   @return [Hash] the user_options passed to the representer
        attr_reader :association, :model, :user_options

        # Initializes the binding.
        #
        # @param association [Reflection] the reflection
        # @param model [ActiveRecord::Base] the record to represent
        # @param user_options [Hash] the user_options passed to the representer
        def initialize(association:, model:, user_options:)
          @association = association
          @model = model
          @user_options = user_options
        end

        # Returns the data to represent (a single record or a collection, depending on the
        # association type).
        #
        # If the association is a collection, paginates it with the params hash.
        #
        # @return [Representer::Base]
        def represent
          value = value_for_representing
          return nil unless value

          association.representer_klass.new(value).to_hash(user_options: user_options.merge(
            include: unnested_includes
          ))
        end

        # Returns the ID(s) related to the association.
        #
        # @return [Fixnum|Array<Fixnum>]
        def represent_ids
          getter_name = if association.collection?
            "#{association.name.to_s.singularize}_ids"
          else
            "#{association.name}_id"
          end

          model.send(getter_name)
        end

        private

        def params
          user_options[:params]
        end

        def unnested_includes
          user_options[:include].select do |include_name|
            include_name.start_with?("#{association.name}__")
          end.map do |include_name|
            include_name.sub("#{association.name}__", '')
          end
        end

        def value_for_representing
          value = model.send(association.name)

          if association.collection?
            Paginator.new(
              page_proc: -> (params) { params[association.options[:page_param]] },
              per_page_proc: -> (params) { params[association.options[:per_page_param]] || association.options[:per_page] },
            ).paginate(relation: value, params: params)
          else
            value
          end
        end
      end
    end
  end
end
