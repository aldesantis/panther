module Panther
  class Paginator
    # A pagination engine is simply a thiny wrapper around a pagination library (e.g. Kaminari,
    # will_paginate).
    #
    # It provides pagination and detection (is the library installed?) features to the paginator.
    #
    # @abstract Subclass and override both {.installed?} and {.paginate} to implement an engine
    class Engine
      class << self
        # Returns whether the library used by this pagination engine is installed. This could be
        # as simple as checking if a constant is defined, or involve more complex logic.
        #
        # @return [Boolean] whether the library is installed
        #
        # @raise [NotImplementedError]
        def installed?
          fail NotImplementedError
        end

        # Paginates a relation with the provided options.
        #
        # @param relation [ActiveRecord::Relation] a relation to paginate
        # @param page [Fixnum] the page number
        # @param per_page [Fixnum] the number of records to show on each page
        #
        # @return [ActiveRecord::Relation] the paginated relation
        #
        # @raise [NotImplementedError]
        def paginate(relation:, page:, per_page:)
          fail NotImplementedError
        end
      end
    end
  end
end
