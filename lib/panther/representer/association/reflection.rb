# frozen_string_literal: true
module Panther
  module Representer
    module Association
      # An association reflection holds all the information about an association.
      #
      # It is instantiated by {ClassMethods#association}.
      #
      # @author Alessandro Desantis <desa.alessandro@gmail.com>
      class Reflection
        # @!attribute [r] name
        #   @return [Symbol] the association name
        #
        # @!attribute [r] options
        #   @return [Hash] the association's options
        attr_reader :name, :options

        # Initializes the reflection.
        #
        # @param name [String|Symbol] the association's name
        # @param options [Hash] the association's options
        #
        # @option options [TrueClass|FalseClass] :expose_id whether to expose the IDs of the
        #   associated records when they are not being sideloaded
        # @options options [Proc] if a condition that must be +true+ to show the association
        # @options options [Proc] unless a condition that must be +false+ to show the association
        # @options options [Proc] page_proc collections only: a proc accepting the params hash and
        #   returning the current page for this association (the default proc returns the
        #   +[association_name]_page+ param)
        # @options options [Proc] per_page_proc collections only: a proc accepting the params hash
        #   and returning the number of records to show on each page (the default proc returns the
        #   +[association_name]_per_page+ param or 10 if it isn't present)
        def initialize(name, options = {})
          @name = name.to_sym
          @options = options
          @namer = Namer.new(@options[:decorator_klass])
          @options = default_options.merge(options)
        end

        # Returns the representer to use for this association (resource or collection representer,
        # depending on the association type).
        #
        # @return [Representer::Base] the representer
        def representer_klass
          representer_module = "::#{@namer.namespace_module}::#{reflection.class_name}::Representer"

          if collection?
            "#{representer_module}::Collection"
          else
            "#{representer_module}::Resource"
          end.constantize
        end

        # Returns the model related to this association.
        #
        # @return [ActiveRecord::Base]
        def model_klass
          reflection.class_name.constantize
        end

        # Returns whether this is a single association.
        #
        # @return [Boolean]
        def single?
          !reflection.collection?
        end

        # Returns whether this is a collection association.
        #
        # @return [Boolean]
        def collection?
          !single?
        end

        # Evaluates the +if+ and +unless+ options of the associations (if present), in the
        # given context and passing the provided arguments.
        #
        # Internally, uses +instance_exec+ to change the context.
        #
        # @param context [Object] the object in which to evaluate the procs
        # @param **args [Hash] arguments to delegate to the procs
        #
        # @return [Boolean] the result of the evaluation
        def evaluate_conditions(context:, **args)
          return false if options[:if] && !context.instance_exec(args, &options[:if])
          return false if options[:unless] && context.instance_exec(args, &options[:unless])

          true
        end

        private

        def default_options
          { expose_id: true }.tap do |defaults|
            defaults.merge(
              page_proc: -> (params) { params["#{name}_page"] },
              per_page_proc: -> (params) { params["#{name}_per_page"] || 10 }
            ) if collection?
          end
        end

        def reflection
          @namer.resource_model.reflect_on_association(name)
        end
      end
    end
  end
end
