# frozen_string_literal: true

require "hanami/helpers"
require "dry/core/basic_object"

module Hanami
  module Helpers
    class ApplicationHelpers < Dry::Core::BasicObject
      include Hanami::Helpers

      attr_reader :routes

      def initialize(application_name:, routes:)
        super()
        @application_name = application_name
        @routes = routes
      end

      def __inspect
        " (#{@application_name} view helpers)"
      end
    end
  end
end
