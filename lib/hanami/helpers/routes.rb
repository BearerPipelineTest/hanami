# frozen_string_literal: true

module Hanami
  module Helpers
    # Hanami application routes helpers, available in views, templates, parts.
    #
    # @see Hanami::Router::UrlHelpers
    # @since 2.0.0
    class Routes
      # @since 2.0.0
      # @api private
      def initialize(router:)
        @router = router
      end

      # @see Hanami::Router::UrlHelpers#path
      def path(...)
        @router.path(...)
      end

      # @see Hanami::Router::UrlHelpers#url
      def url(...)
        @router.url(...)
      end
    end
  end
end
