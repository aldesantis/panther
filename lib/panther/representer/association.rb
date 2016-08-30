# frozen_string_literal: true
module Panther
  module Representer
    # This module provides support for sideloading associations in your API calls.
    #
    # Include it in your resource representer and configure sideloading. This will allow your
    # users to make API calls like +/api/v1/users/1?include=posts&posts_page=2+ to load the second
    # page of the user's posts in addition to their profiles.
    #
    # @example An example sideloading configuration
    #   module API
    #     module V1
    #       module Post
    #         module Representer
    #           class Resource < ::Panther::Representer::Base
    #             include ::Panther::Representer::Association
    #
    #             association :author
    #             association :post
    #           end
    #         end
    #       end
    #     end
    #   end
    module Association
      def self.included(base)
        base.class_eval do
          extend ClassMethods

          include Naming
          @associations = {}
        end
      end

      module ClassMethods
        # Configures sideloading for the provided association.
        #
        # @param name [Symbol] The association's name
        # @param expose_id [TrueClass|FalseClass] Whether to expose the IDs of the associated
        #   records when they are not being sideloaded
        def association(name, options = {})
          @associations[name.to_sym] = default_association_options_for(name).merge(options)

          define_association_property name
          define_association_getter name

          if @associations[name.to_sym][:expose_id]
            define_association_id_property name
            define_association_id_getter name
          end
        end

        # Returns the appropriate representer for the given association (collection or resource,
        # depending on the association type).
        #
        # @param name [String|Symbol] The association's name
        #
        # @return [Panther::Representer::Base]
        def association_representer(name)
          if association_collection?(name)
            "#{association_representer_module(name)}::Collection"
          else
            "#{association_representer_module(name)}::Resource"
          end.constantize
        end

        # Returns the record(s) related with the given association. If the association is a
        # collection, paginates it.
        #
        # @param model [ActiveRecord::Base] The model
        # @param name [String|Symbol] The association's name
        # @param params [Hash] The +params+ passed to the representer
        #
        # @return [ActiveRecord::Relation|ActiveRecord::Base]
        def association_represented(model:, name:, params:)
          relation = model.send(name)

          if association_collection?(name)
            paginate_association(
              relation: relation,
              name: name,
              params: params
            )
          else
            relation
          end
        end

        private

        def paginate_association(relation:, name:, params:)
          page = params[@associations[name.to_sym][:page_param]]

          per_page = if params[@associations[name.to_sym][:per_page_param]]
            params[@associations[name.to_sym][:per_page_param]]
          else
            @associations[name.to_sym][:per_page]
          end

          relation.paginate(
            page: page,
            per_page: per_page
          )
        end

        def association_collection?(name)
          association_reflection(name).collection?
        end

        def default_association_options_for(name)
          {
            expose_id: false,
            per_page: 10,
            per_page_param: "#{name}_per_page",
            page_param: "#{name}_page"
          }
        end

        def association_reflection(name)
          resource_model.reflect_on_association(name)
        end

        def association_representer_module(name)
          "::#{namespace_module}::#{association_reflection(name).class_name}::Representer"
            .constantize
        end

        def define_association_property(name)
          property(
            name,
            if: -> (user_options:, **) { user_options[:include].include?(name.to_s) },
            exec_context: :decorator
          )
        end

        def association_id_property_name(name)
          if association_collection?(name)
            "#{name}_ids"
          else
            "#{name}_id"
          end
        end

        def define_association_id_property(name)
          property(
            association_id_property_name(name),
            if: -> (user_options:, **) { !user_options[:include].include?(name.to_s) },
            exec_context: :decorator
          )
        end

        def define_association_id_getter(name)
          model_getter_name = if association_collection?(name)
            "#{name.to_s.singularize}_ids"
          else
            "#{name}_id"
          end

          define_method association_id_property_name(name) do
            represented.send(model_getter_name)
          end
        end

        def define_association_getter(name)
          representer_klass = association_representer(name)

          define_method name do |user_options:, **|
            collection = self.class.association_represented(
              model: represented,
              name: name,
              params: user_options[:params]
            )

            representer_klass.new(collection)
          end
        end
      end
    end
  end
end
