require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "nextbbs"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = "Tokyo"

    # DBのタイムゾーンがJST(or 現地時刻)の場合
    # config.active_record.default_timezone = :local

    # DBのタイムゾーンがUTCの場合
    config.active_record.default_timezone = :utc

    #　以下の記述を追記する(設定必須)
    config.i18n.default_locale = :ja # デフォルトのlocaleを日本語(:ja)にする
  end
end
