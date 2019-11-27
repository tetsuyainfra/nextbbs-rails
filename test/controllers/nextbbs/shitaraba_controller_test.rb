require 'test_helper'

module Nextbbs
  class ShitarabaControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get index" do
      get shitaraba_index_url
      assert_response :success
    end

    test "should get dat" do
      get shitaraba_dat_url
      assert_response :success
    end

  end
end
