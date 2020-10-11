require_dependency "nextbbs/application_controller"

module Nextbbs
  class PageController < ApplicationController
    def index
    end

    def test_flash
      flash.now[:notice] = "notice message"
      flash.now[:alert] = "alert message"
    end
  end
end
