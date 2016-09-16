# frozen_string_literal: true
module Panther
  class Paginator
    # Kaminari pagination engine
    class KaminariEngine < Engine
      class << self
        # Determines whether Kaminari is installed by checking if the +Kaminari+ constant
        # is defined.
        #
        # @return [Boolean] whether Kaminari is installed
        def installed?
          defined?(Kaminari)
        end

        # Paginates a relation with the provided options.
        #
        # Respects +Kaminari.config.page_method_name+.
        #
        # @param relation [ActiveRecord::Relation] a relation to paginate
        # @param page [Fixnum] the page number
        # @param per_page [Fixnum] the number of records to show on each page
        #
        # @return [ActiveRecord::Relation] the paginated relation
        def paginate(relation:, page:, per_page:)
          relation.send(Kaminari.config.page_method_name, page).per(per_page)
        end
      end
    end
  end
end
