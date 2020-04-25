require "nextbbs/engine"
require "nextbbs/config"
require 'nextbbs/extension'
require 'nextbbs/extensions/pundit'

module Nextbbs

  class << self
    attr_reader :config

    def configure
      @config = Config.new
      yield config
      @config.freeze
    end
  end
end
