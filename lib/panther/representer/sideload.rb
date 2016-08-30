module Panther
  module Representer
    module Sideload
      def self.included(base)
        base.class_eval do
          include Naming
          extend ClassMethods
        end
      end

      module ClassMethods
        def sideload_association(name)
          class_eval do
            property(
              name,
              if: -> (user_options:, **) { user_options[:include].include?(name.to_s) },
              exec_context: :decorator
            )
          end

          define_method name do |user_options:, **|
            collection = self.class.association_collection(
              model: represented,
              name: name,
              user_options: user_options
            )

            self.class.association_representer(name).new(collection)
          end
        end

        def association_representer(name)
          class_name = resource_model.reflect_on_association(name).class_name
          "::#{namespace_module}::#{class_name}::Representer::Collection".constantize
        end

        def association_collection(model:, name:, user_options:)
          relation = model.send(name)
          relation.paginate(page: user_options[:params]["#{name}_page"])
        end
      end
    end
  end
end
