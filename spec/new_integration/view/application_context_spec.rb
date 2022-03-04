# frozen_string_literal: true

RSpec.describe "Application context", :application_integration do
  it "setups application and slice view context" do
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

      write "slices/main/lib/view/base.rb", <<~RUBY
        require "test_app/view/base"

        module Main
          module View
            class Base < TestApp::View::Base
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

      ctx = TestApp::View::Base.config.default_context
      expect(ctx).to be_kind_of(TestApp::View::Context)

      ctx = Main::View::Base.config.default_context
      expect(ctx).to be_kind_of(Main::View::Context)
    end
  end
end

RSpec.describe "Application context / Helpers", :application_integration do
  it "accesses application helpers" do
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
