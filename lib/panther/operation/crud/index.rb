# frozen_string_literal: true
module Panther
  module Operation
    # Default index operation
    #
    # This can be used as the starting point for index operations or standalone.
    #
    # @author Alessandro Desantis <desa.alessandro@gmail.com>
    #
    # @abstract Subclass and override {#collection} to implement an index operation
    #
    # @example A basic index operation
    #   module API
    #     module V1
    #       module Post
    #         module Operation
    #           class Index < ::Panther::Operation::Index
    #             protected
    #
    #             def collection
    #               ::Post.all
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    class Index < Base
      # Retrieves the collection, paginates it and exposes it through the collection representer.
      #
      # Responds with the OK HTTP status code and the paginated collection.
      #
      # @see #collection
      def call
        relation = Paginator.new(paginator_options).paginate(relation: collection, params: params)
        respond_with resource: self.class.collection_representer_klass.new(relation)
      end

      protected

      # Returns the options to forward to the {Paginator}. By default, this is an empty hash,
      # so the {Paginator}'s defaults will be used.
      #
      # @return [Hash]
      #
      # @see Paginator
      def paginator_options
        {}
      end

      # Returns the collection to expose in the operation.
      #
      # This can be used for scoping the collection (e.g. to the current user) or applying filters.
      #
      # @return [ActiveRecord::Relation]
      #
      # @example Scoping the collection
      #   module API
      #     module V1
      #       module Post
      #         module Operation
      #           module Index < ::Panther::Operation::Index
      #             protected
      #
      #             def collection
      #               ::Post.written_by(params[:current_user])
      #             end
      #           end
      #         end
      #       end
      #     end
      #   end
      #
      # @example Filtering the collection
      #   module API
      #     module V1
      #       module Post
      #         module Operation
      #           module Index < ::Panther::Operation::Index
      #             protected
      #
      #             def collection
      #               relation = ::Post.all
      #               relation = relation.by_title(params[:by_title]) if params[:by_title].present?
      #               relation
      #             end
      #           end
      #         end
      #       end
      #     end
      #   end
      def collection
        fail NotImplementedError
      end
    end
  end
end
