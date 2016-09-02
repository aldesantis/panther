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

          @associations = {}
        end
      end

      private

      def association_represented(model:, name:, params:)
        relation = model.send(name)

        if @associations[name].collection?
          Paginator.paginate(association: @associations[name], relation: relation, params: params)
        else
          relation
        end
      end

      module ClassMethods
        # Configures sideloading for the provided association.
        #
        # @param name [Symbol] The association's name
        # @param options [Hash] The options hash
        #
        # @option options [TrueClass|FalseClass] :expose_id Whether to expose the IDs of the
        #   associated records when they are not being sideloaded
        # @option options [Symbol] :page_param The name of the parameter containing the current page
        # @option options [Fixnum] :per_page The default number of records to show per page
        # @option options [Symbol|NilClass] :per_page_param The name of the parameter containing the
        #   number of records to show per page, or +nil+ to disable the feature
        def association(name, options = {})
          @associations[name.to_sym] = Reflection.new(name, options.merge(
            decorator_klass: self
          ))

          define_association_property name
          define_association_getter name

          if @associations[name.to_sym][:expose_id]
            define_association_id_property name
            define_association_id_getter name
          end
        end

        private

        def define_association_property(name)
          property(
            name,
            if: -> (user_options:, **) { user_options[:include].include?(name.to_s) },
            exec_context: :decorator
          )
        end

        def define_association_id_property(name)
          property_name = if association_collection?(name)
            "#{name}_ids"
          else
            "#{name}_id"
          end

          property(
            property_name,
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
            value = association_represented(
              model: represented,
              name: name,
              params: user_options[:params]
            )

            return nil if value.nil?

            @associations[name.to_sym].representer_klass.new(value)
          end
        end
      end
    end
  end
end
