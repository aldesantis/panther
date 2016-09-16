# frozen_string_literal: true
module Panther
  # Provides support for pagination with different libraries through a common API.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  class Paginator
    # @!attribute [r] options
    #   @return [Hash] the options passed to the paginator
    attr_reader :options

    # Initializes the paginator.
    #
    # @param options [Hash] the options hash
    # @option options [Symbol|String] page_param the page number param's name
    #   (+page+ by default)
    # @options options [Symbol|String] per_page_param the per_page number param's name
    #   (+per_page+ by default)
    # @options options [Fixnum] per_page the default per_page value (10 by default)
    def initialize(options = {})
      @options = {
        page_param: :page,
        per_page_param: :per_page,
        per_page: 10
      }.merge(options)
    end

    # Paginates a relation with the given params, with the first pagination engine found.
    #
    # Pagination engines are looked for in the following order:
    #
    # - Kaminari
    # - will_paginate
    #
    # @param relation [Object] a paginatable relation
    # @param params [Hash] a params hash
    #
    # @return [Object] the paginated relation
    def paginate(relation:, params:)
      pagination_params = extract_pagination_params_from params
      send "paginate_with_#{pagination_engine}", { relation: relation }.merge(pagination_params)
    end

    private

    def paginate_with_will_paginate(relation:, page:, per_page:)
      relation.paginate(
        page: page,
        per_page: per_page
      )
    end

    def paginate_with_kaminari(relation:, page:, per_page:)
      relation.page(page).per(per_page)
    end

    def extract_pagination_params_from(params)
      page = params[options[:page_param]]

      per_page = if params[options[:per_page_param]]
        params[options[:per_page_param]]
      else
        options[:per_page]
      end

      {
        page: page,
        per_page: per_page
      }
    end

    def pagination_engine
      if defined?(WillPaginate)
        :will_paginate
      elsif defined?(Kaminari)
        :kaminari
      else
        fail 'Could not find a supported pagination library'
      end
    end
  end
end
