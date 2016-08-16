# frozen_string_literal: true
require 'reform/form/coercion'

module Panther
  module Contract
    # Base contract
    #
    # Contracts are used to parse and validate incoming data, usually in write (create/update)
    # operations.
    #
    # They are just a thin layer on top of {https://github.com/apotonick/reform Reform}.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @see https://github.com/apotonick/reform Reform
    #
    # @example A simple contract
    #   module API
    #     module V1
    #        module User
    #          module Contract
    #            class Base < ::Panther::Contract::Base
    #              property :email
    #
    #              validates :email, presence: true, format: { with: /@/ }
    #              validates_uniqueness_of :email, case_sensitive: false
    #            end
    #          end
    #        end
    #      end
    #   end
    #
    # @example Contracts can inherit from other contracts
    #   module API
    #     module V1
    #       module User
    #         module Contract
    #           class Create < Base
    #             property :password
    #
    #             validates :password, presence: true, length: { in: 8..128 }
    #           end
    #         end
    #       end
    #     end
    #   end
    class Base < Reform::Form
      include Coercion
    end
  end
end
