require "rails/generators"
# require File.expand_path("../utils", __FILE__)

module Nextbbs
  class InstallGenerator < Rails::Generators::Base
    desc "Creates a Nextbbs initializer and Add mountable moduel into routes.rb"

    # source_root File.expand_path("templates", __dir__)
    def set_source_paths
      @source_paths = [
        File.expand_path("templates", __dir__),
      ]
    end

    def copy_initializer_file
      template "nextbbs.rb.tt", "config/initializers/nextbbs.rb"
    end

    def install_migrations
      Dir.chdir(Rails.root) do `rake nextbbs:install:migrations` end
    end

    # 上のタスクはrake -Tから隠したい・・・
    # rake -W で定義された場所がわかる

    def mount_engine
      route("mount Nextbbs::Engine, :at => '/bbs', :as => 'nextbbs'")
    end
  end # class
end
