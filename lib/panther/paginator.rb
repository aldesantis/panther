# frozen_string_literal: true
module Panther
  # Provides support for pagination with different libraries through a common API.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  class Paginator
    SUPPORTED_ENGINES = [:will_paginate, :kaminari].freeze

    # @!attribute [r] options
    #   @return [Hash] the options passed to the paginator
    attr_reader :options

    # Initializes the paginator.
    #
    # @param options [Hash] the options hash
    #
    # @options options [Proc] page_proc A proc returning the current page. Receives the params hash
    #   as argument. By default, uses the +page+ parameter.
    # @options options [Proc] per_page_proc A proc returning the number of records to show on each
    #   page. Receives the params hash as argument. By default, uses the +per_page+ parameter or
    #   10 records per page, if not present.
    # @options options [Symbol] engine The pagination engine to use. By default, uses the first
    #   available engine. See {SUPPORTED_ENGINES} for a list of supported engines and the order
    #   in which they are detected.
    def initialize(options = {})
      @options = {
        page_proc: -> (params) { params[:page] },
        per_page_proc: -> (params) { params[:per_page] || 10 },
        engine: detect_engine
      }.merge(options)
    end

    # Paginates a relation with the given params.
    #
    # @param relation [Object] a paginatable relation
    # @param params [Hash] a params hash
    #
    # @return [Object] the paginated relation
    def paginate(relation:, params:)
      pagination_params = extract_pagination_params_from params
      engine_klass(options[:engine]).paginate({ relation: relation }.merge(pagination_params))
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
