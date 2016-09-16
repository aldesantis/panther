# frozen_string_literal: true
module Panther
  class Paginator
    # will_paginate pagination engine
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    class WillPaginateEngine < Engine
      class << self
        # Determines whether will_paginate is installed by checking if the +WillPaginate+ constant
        # is defined.
        #
        # @return [Boolean] whether will_paginate is installed
        def installed?
          defined?(WillPaginate)
        end

        # Paginates a relation with the provided options.
        #
        # @param relation [ActiveRecord::Relation] a relation to paginate
        # @param page [Fixnum] the page number
        # @param per_page [Fixnum] the number of records to show on each page
        #
        # @return [ActiveRecord::Relation] the paginated relation
        def paginate(relation:, page:, per_page:)
          relation.paginate(
            page: page,
            per_page: per_page
          )
        end
      end
    end
  end
end
