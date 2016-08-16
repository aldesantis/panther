# frozen_string_literal: true
module Panther
  module Contract
    # Coercion types
    #
    # This module can be used to add coercion support to a contract through the awesome
    # {http://dry-rb.org/gems/dry-types Dry::Types} gem.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @see http://dry-rb.org/gems/dry-types Dry::Types
    #
    # @example A contract with coercion
    #   module API
    #     module V1
    #        module User
    #          module Contract
    #            class Base < ::Panther::Contract::Base
    #              property :email, type: Types::Coercible::String
    #            end
    #          end
    #        end
    #      end
    #    end
    module Types
      include Dry::Types.module
    end
  end
end
