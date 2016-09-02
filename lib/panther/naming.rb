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
      @namer = Namer.new(self)

      delegate(*[
        :namespace_module, :resource_module, :resource_name, :resource_model, :representer_klass,
        :collection_representer_klass, :policy_klass
      ], to: :@namer)
    end
  end
end
