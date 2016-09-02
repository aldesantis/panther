module Panther
  module Representer
    module Association
      class Paginator
        attr_reader :association

        def initialize(association)
          @association = association
        end

        def paginate(relation:, params:)
          options = extract_pagination_options_from params
          send "paginate_with_#{pagination_engine}", relation: relation, options: options
        end

        private

        def paginate_with_will_paginate(relation:, options:)
          relation.paginate options
        end

        def paginate_with_kaminari(relation:, options:)
          relation.page(options[:page]).per(options[:per_page])
        end

        def extract_pagination_options_from(params)
          page = params[association.name][:page_param]

          per_page = if params[association.name][:per_page_param]
            params[association.name][:per_page_param]
          else
            association.name[:per_page]
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
            raise 'Could not find a supported pagination library'
          end
        end
      end
    end
  end
end