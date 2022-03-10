# frozen_string_literal: true

RSpec.describe "View helpers / Routes", :application_integration do
  it "exposes helpers" do
    with_tmp_directory(Dir.mktmpdir) do
      write "config/application.rb", <<~RUBY
        require "hanami"

        module TestApp
          class Application < Hanami::Application
          end
        end
      RUBY

      write "config/routes.rb", <<~RUBY
        require "hanami/application/routes"

        module TestApp
          class Routes < Hanami::Application::Routes
            define do
              slice :admin, at: "/admin" do
                get "/users", to: "users.index", as: :users
              end
            end
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

      write "slices/admin/lib/view/base.rb", <<~RUBY
        require "test_app/view/base"

        module Admin
          module View
            class Base < TestApp::View::Base
            end
          end
        end
      RUBY

      write "slices/admin/lib/view/context.rb", <<~RUBY
        require "test_app/view/context"

        module Admin
          module View
            class Context < TestApp::View::Context
            end
          end
        end
      RUBY

      write "slices/admin/views/users/index.rb", <<~RUBY
        module Admin
          module Views
            module Users
              class Index < View::Base
                expose :admin_users_path do |context:|
                  context.helpers.routes.path(:admin_users)
                end
              end
            end
          end
        end
      RUBY

      write "slices/admin/templates/layouts/application.html.erb", <<~RUBY
        <%= yield %>
      RUBY

      write "slices/admin/templates/users/index.html.erb", <<~RUBY
        Template: "<%= helpers.routes.path(:admin_users) %>"
        Exposure: "<%= admin_users_path %>"
      RUBY

      require "hanami/prepare"

      ctx = Admin::View::Context.new
      view = Admin::Slice["views.users.index"]

      # TODO: @timriley to remove the need for explicit context passing
      actual = view.(context: ctx).to_s

      expect(actual).to include(%(Template: "/admin/users"))
      expect(actual).to include(%(Exposure: "/admin/users"))
    end
  end
end
