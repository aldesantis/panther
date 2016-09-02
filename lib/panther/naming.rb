# frozen_string_literal: true
module Panther
  # Naming mixin
  #
  # Provides some useful methods to retrieve class and module names. These are used in the
  # default CRUD operations.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  module Naming
    def self.included(klass)
      klass.class_eval do
        @namer = Namer.new(self)
      end

      klass.extend ClassMethods
    end

    module ClassMethods
      [
        :namespace_module, :resource_module, :resource_name, :resource_model, :representer_klass,
        :collection_representer_klass, :policy_klass
      ].each do |name|
        define_method name do
          Namer.new(self).send(name)
        end
      end
    end
  end
end
