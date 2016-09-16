# frozen_string_literal: true
module Panther
  # Provides support for pagination with different libraries through a common API.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  class Paginator
    SUPPORTED_ENGINES = [:will_paginate, :kaminari]

    # @!attribute [r] options
    #   @return [Hash] the options passed to the paginator
    attr_reader :options

    # Initializes the paginator.
    #
    # @param options [Hash] the options hash
    #
    # @options options [Proc] page_proc A proc returning the current page. Receives the params hash
    #   as argument.
    # @options options [Proc] per_page_proc A proc returning the number of records to show on each
    #   page. Receives the params hash as argument.
    def initialize(options = {})
      @options = {
        page_proc: -> (params) { params[:page] },
        per_page_proc: -> (params) { params[:per_page] || 10 }
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
      engine_klass(detect_engine).paginate({ relation: relation }.merge(pagination_params))
    end

    private

    def extract_pagination_params_from(params)
      {
        page: options[:page_proc].call(params),
        per_page: options[:per_page_proc].call(params)
      }
    end

    def detect_engine
      SUPPORTED_ENGINES.detect do |engine|
        engine_klass(engine).installed?
      end || fail(
        "Could not find a supported pagination library (#{SUPPORTED_ENGINES.join(', ')} supported"
      )
    end

    def engine_klass(engine)
      "#{self.class.name}::#{engine.to_s.camelize}Engine".constantize
    end
  end
end
