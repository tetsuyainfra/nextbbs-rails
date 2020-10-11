# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"
require "faker"

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase

  # @examaple in fanctional
  # test/controllers/nextbbs/boards_controller_test.rb
  # module Nextbbs
  #   class BoardsControllerTest < ActionController::TestCase   # <---
  #    include Devise::Test::ControllerHelpers
  #    test "hoge" do
  #      log_in(User.first)
  #    end
  #   end
  # end
  # @examaple in integration
  # test/system/nextbbs/boards_test.rb
  # module Nextbbs
  #   class BoardsControllerTest < ActionDispatch::IntegrationTest # <--
  #    include Warden::Test::Helpers
  #    test "hoge" do
  #      log_in(User.first)
  #    end
  #   end
  # end
  def log_in(user)
    if defined?(:login_as)
      #use warden helper
      login_as(user, :scope => :user)
    else #controller_test, model_test
      #use devise helper
      sign_in(user)
    end
  end

  def log_out(scope = :user)
    if defined?(:login_as)
      #use warden helper
      logout(scope)
    else #controller_test, model_test
      #use devise helper
      sign_out scope
    end
  end
end

if ENV.fetch("LOG_OUTPUT_CONSOLE", false)
  # ログをコンソールに出力する
  Rails.logger = Logger.new(STDOUT) # 追記
  # SQLのログ
  # ActiveRecord::Base.logger = Logger.new(STDOUT) # 追記
end
