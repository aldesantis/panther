# frozen_string_literal: true
require 'reform/form/coercion'

module Panther
  module Contract
    class Base < Reform::Form
      include Coercion
      include Dry::Types.module
    end
  end
end
