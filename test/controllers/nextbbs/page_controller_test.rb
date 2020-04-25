require 'test_helper'

module Nextbbs
  class PageControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get page_index_url
      assert_response :success
    end

  end
end
