# frozen_string_literal: true

RSpec.describe "Application helpers: format_number", :application_integration do
  xspecify "it does something" do
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

      write "slices/main/views/users/show.rb", <<~RUBY
        module Main
          module Views
            module Users
              class Show < Main::View::Base
                expose :balance

                expose :formatted_balance do |balance:, context:|
                  context.helpers.format_number(balance)
                end
              end
            end
          end
        end
      RUBY

      write "slices/main/templates/layouts/application.html.slim", <<~SLIM
        html
          body
            == yield
      SLIM

      # CASE 1
      #
      #   NoMethodError:
      #     undefined method `helpers' for #<Hanami::View::Context _options={}>
      #
      #   NOTE: this should be instance of `Main::View::Context`, not `Hanami::View::Context`
      #
      write "slices/main/templates/users/show.html.slim", <<~'SLIM'
        h1 Balance: #{helpers.format_number(balance)}
      SLIM

      # CASE 2
      #
      #  NoMethodError:
      #    undefined method `helpers' for #<Hanami::View::Context _options={}>
      #
      #   NOTE: this should be instance of `Main::View::Context`, not `Hanami::View::Context`
      #
      write "slices/main/templates/users/show.html.slim", <<~'SLIM'
        h1 Balance: #{formatted_balance}
      SLIM

      require "hanami/prepare"

      rendered = Main::Slice["views.users.show"].(balance: 1234.5678)
      expect(rendered.to_s).to eq "<html><body><h1>Balance: 1,234.56</h1></body></html>"
    end
  end
end
