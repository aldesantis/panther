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

          if @associations[name.to_sym].options[:expose_id]
            define_association_id_property name
            define_association_id_getter name
          end
        end

        private

        def define_association_property(name)
          association = @associations[name]

          property(
            name,
            if: proc { |user_options:, **args|
              user_options[:include].include?(name.to_s) &&
              association.evaluate_conditions(args.merge(context: self, user_options: user_options))
            },
            exec_context: :decorator
          )
        end

        def define_association_id_property(name)
          association = @associations[name]

          property_name = if association.collection?
            "#{name}_ids"
          else
            "#{name}_id"
          end

          property(
            property_name,
            if: proc { |user_options:, **args|
              !user_options[:include].include?(name.to_s) &&
              association.evaluate_conditions(args.merge(context: self, user_options: user_options))
            },
            exec_context: :decorator
          )
        end

        def define_association_id_getter(name)
          property_name = if @associations[name].collection?
            "#{name}_ids"
          else
            "#{name}_id"
          end

          association = @associations[name]

          define_method property_name do |user_options:, **|
            Binding.new(
              association: association,
              model: represented,
              user_options: user_options
            ).represent_ids
          end
        end

        def define_association_getter(name)
          association = @associations[name]

          define_method name do |user_options:, **|
            Binding.new(
              association: association,
              model: represented,
              user_options: user_options
            ).represent
          end
        end
      end
    end
  end
end
