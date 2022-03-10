# frozen_string_literal: true

RSpec.describe "View helpers", :application_integration do
  it "application view exposes application helpers" do
    with_tmp_directory(Dir.mktmpdir) do
      write "config/application.rb", <<~RUBY
        require "hanami"

        module TestApp
          class Application < Hanami::Application
          end
        end
      RUBY

      write "lib/test_app/view/base.rb", <<~RUBY
        require "hanami/view"

        module TestApp
          module View
            class Base < Hanami::View
            end
          end
        end
      RUBY

      write "lib/test_app/view/context.rb", <<~RUBY
        require "hanami/view/context"

        module TestApp
          module View
            class Context < Hanami::View::Context
            end
          end
        end
      RUBY

      write "slices/main/lib/view/context.rb", <<~RUBY
        require "test_app/view/context"

        module Main
          module View
            class Context < TestApp::View::Context
            end
          end
        end
      RUBY

      require "hanami/prepare"

      ctx = TestApp::View::Context.new
      expect(ctx.helpers).to be_kind_of(Hanami::Helpers::ApplicationHelpers)

      ctx = Main::View::Context.new
      expect(ctx.helpers).to be_kind_of(Hanami::Helpers::ApplicationHelpers)
    end
  end
end
