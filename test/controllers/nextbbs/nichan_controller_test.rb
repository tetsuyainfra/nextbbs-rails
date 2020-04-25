require 'test_helper'

module Nextbbs
  class NichanControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get setting" do
      get nichan_setting_url
      assert_response :success
    end

    test "should get subject" do
      get nichan_subject_url
      assert_response :success
    end

    test "should get dat" do
      get nichan_dat_url
      assert_response :success
    end

    test "should get read_cgi" do
      get nichan_read_cgi_url
      assert_response :success
    end

    test "should get bbs_cgi" do
      get nichan_bbs_cgi_url
      assert_response :success
    end

  end
end
