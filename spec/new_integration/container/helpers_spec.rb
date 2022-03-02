# frozen_string_literal: true

RSpec.describe "Application helpers", :application_integration do
  specify "Expose helpers in application container" do
    with_tmp_directory(Dir.mktmpdir) do
      write "config/application.rb", <<~RUBY
        require "hanami"

        module TestApp
          class Application < Hanami::Application
          end
        end
      RUBY

      require "hanami/prepare"

      helpers = TestApp::Application["helpers"]

      expect(helpers).to be_kind_of(Dry::Core::BasicObject)
      expect(helpers.inspect).to match("TestApp view helpers")
      expect(helpers.class.included_modules).to include(Hanami::Helpers)
    end
  end
end
