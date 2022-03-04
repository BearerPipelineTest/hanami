# frozen_string_literal: true

Hanami.application.register_provider :helpers do
  start do
    begin
      require "hanami/helpers/application_helpers"
      require "hanami/helpers/routes"
    rescue LoadError # rubocop:disable Lint/SuppressedException
    end

    if defined?(Hanami::Helpers::ApplicationHelpers)
      application = Hanami.application

      routes = Hanami::Helpers::Routes.new(router: application.router)
      namespace = application.namespace

      # TODO: check if `hanami-assets` is bundled, and inject its helpers
      helpers = Hanami::Helpers::ApplicationHelpers.new(
        application_name: namespace.to_s,
        routes: routes
      )

      register :helpers, helpers
    end
  end
end
