require "sequenced"
require "counter_culture"
require "slim"
require "rails-i18n"
# require "devise-i18n"

module Nextbbs
  class Engine < ::Rails::Engine
    isolate_namespace Nextbbs
  end
end
