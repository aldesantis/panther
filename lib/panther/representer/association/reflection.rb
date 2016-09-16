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

        # Initializes the reflection. The +type+ and +source_klass+ options are mandatory.
        #
        # @param name [String|Symbol] the association's name
        # @param options [Hash] the association's options
        #
        # @options options [Symbol] :type the type of the association (+has_one+, +has_many+, ...)
        # @options options [Class] :source_klass the representer defining the association
        # @options options [Symbol] :resource_module the module containing the resource (by default,
        #   this is computed from the name and +source_klass+)
        # @option options [TrueClass|FalseClass] :expose_id whether to expose the IDs of the
        #   associated records when they are not being sideloaded
        # @options options [Proc] :if a condition that must be +true+ to show the association
        # @options options [Proc] :unless a condition that must be +false+ to show the association
        # @options options [Proc] :page_proc collections only: a proc accepting the params hash and
        #   returning the current page for this association (the default proc returns the
        #   +[association_name]_page+ param)
        # @options options [Proc] :per_page_proc collections only: a proc accepting the params hash
        #   and returning the number of records to show on each page (the default proc returns the
        #   +[association_name]_per_page+ param or 10 if it isn't present)
        def initialize(name, options = {})
          validate_options(options)

          @name = name.to_sym
          @namer = Namer.new(options[:source_klass])
          @options = compute_options_from(options)
        end

        # Returns the representer to use for this association (resource or collection representer,
        # depending on the association type).
        #
        # @return [Representer::Base] the representer
        def representer_klass
          representer_module = "#{options[:resource_module]}::Representer".constantize

          if collection?
            "#{representer_module}::Collection"
          else
            "#{representer_module}::Resource"
          end.constantize
        end

        # Returns whether this is a single association (+has_one+ or +belongs_to+).
        #
        # @return [Boolean]
        def single?
          single_type?(options[:type])
        end

        # Returns whether this is a collection association (+has_many+ or
        # +has_and_belongs_to_many+).
        #
        # @return [Boolean]
        def collection?
          collection_type?(options[:type])
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

        def compute_options_from(base_options)
          base_options[:expose_id] = true unless base_options.has_key?(:expose_id)

          if collection_type?(base_options[:type])
            base_options[:page_proc] = proc { |params|
              params["#{name}_page"]
            } unless base_options[:page_proc]

            base_options[:per_page_proc] = proc { |params|
              params["#{name}_per_page"] || 10
            } unless base_options[:per_page_proc]
          end

          base_options[:resource_module] = (
            ['', @namer.namespace_module, name.to_s.singularize.camelize]
              .join('::')
              .constantize
          ) unless base_options[:resource_module]

          base_options
        end

        def validate_options(input_options)
          missing_options = [:source_klass, :type].select do |option|
            !input_options.has_key?(option)
          end

          fail "Missing required options #{missing_options.join(', ')}" if missing_options.any?

          fail(
            "#{input_options[:type]} is an invalid association type"
          ) unless single_type?(input_options[:type]) || collection_type?(input_options[:type])
        end

        def single_type?(type)
          type.to_sym.in?([:has_one, :belongs_to])
        end

        def collection_type?(type)
          type.to_sym.in?([:has_many, :has_and_belongs_to_many])
        end
      end
    end
  end
end
