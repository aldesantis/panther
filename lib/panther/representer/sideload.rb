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
    #       module User
    #         module Representer
    #           class Resource < ::Panther::Representer::Base
    #             include ::Panther::Representer::Sideload
    #
    #             sideload_association :posts
    #           end
    #         end
    #       end
    #     end
    #   end
    module Sideload
      def self.included(base)
        base.class_eval do
          include Naming
          extend ClassMethods
        end
      end

      private

      def association_reflection(name)
        self.class.resource_model.reflect_on_association(name)
      end

      def association_representer_module(name)
        "::#{self.class.namespace_module}::#{association_reflection(name).class_name}::Representer"
      end

      def association_collection?(name)
        association_reflection(name).collection?
      end

      def association_representer(name)
        if reflection.collection?
          "#{association_representer_module(name)}::Collection"
        else
          "#{association_representer_module(name)}::Resource"
        end.constantize
      end

      def association_represented(model:, name:, user_options:)
        relation = model.send(name)

        if association_collection?(name)
          relation.paginate(page: user_options[:params]["#{name}_page"])
        else
          relation
        end
      end

      module ClassMethods
        # Configures sideloading for the provided association.
        #
        # @param name [Symbol] The association's name
        def sideload_association(name)
          define_association_property name
          define_association_getter name
        end

        private

        def define_association_property(name)
          property(
            name,
            if: -> (user_options:, **) { user_options[:include].include?(name.to_s) },
            exec_context: :decorator
          )
        end

        def define_association_getter(name)
          define_method name do |user_options:, **|
            collection = association_represented(
              model: represented,
              name: name,
              user_options: user_options
            )

            association_representer(name).new(collection)
          end
        end
      end
    end
  end
end
