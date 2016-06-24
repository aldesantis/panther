# frozen_string_literal: true
module Panther
  module Representer
    class Base < Roar::Decorator
      include Roar::JSON

      defaults render_nil: true
    end
  end
end
