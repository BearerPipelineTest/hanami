# frozen_string_literal: true

Hanami.application.register_provider :helpers do
  start do
    begin
      require "hanami/helpers"
    rescue LoadError # rubocop:disable Lint/SuppressedException
    end

    if defined?(Hanami::Helpers)
      require "dry/core/basic_object"

      helpers = Class.new(Dry::Core::BasicObject) do
        include Hanami::Helpers

        def __inspect
          " (#{Hanami.application.namespace} view helpers)"
        end
      end.new

      register :helpers, helpers
    end
  end
end
