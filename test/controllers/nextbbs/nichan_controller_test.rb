require 'test_helper'


module Nextbbs
  class NichanControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Warden::Test::Helpers

    setup do
      @board = nextbbs_boards(:one)
      @topic = @board.topics.first
      @engine_root_path = "/nextbbs"
    end

    test "should get setting" do
      assert_equal "#{@engine_root_path}/boards/#{@board.id}/SETTING.TXT", nichan_setting_path(@board)

      get nichan_setting_url(@board)
      assert_response :success
    end

    test "should get subject" do
      assert_equal "#{@engine_root_path}/boards/#{@board.id}/subject.txt", nichan_subject_path(@board)

      get nichan_subject_url(@board)
      assert_response :success
    end

    test "should get dat" do
      assert_equal "#{@engine_root_path}/boards/#{@board.id}/dat/#{@topic.id}.dat", nichan_dat_path(@board, @topic)

      get nichan_dat_url(@board, @topic)
      assert_response :success
    end

    test "should get read_cgi" do
      assert_equal "#{@engine_root_path}/boards/test/read.cgi/#{@board.id}/#{@topic.id}", nichan_read_cgi_path(@board, @topic)
      assert_equal "#{@engine_root_path}/boards/test/read.cgi/#{@board.id}/#{@topic.id}/900-", nichan_read_cgi_path(@board, @topic, "900-")
      assert_equal "#{@engine_root_path}/boards/test/read.cgi/#{@board.id}/#{@topic.id}/900-", nichan_read_cgi_path(@board, @topic, query: "900-")

      get nichan_read_cgi_url(@board, @topic)
      assert_response :success

      get nichan_read_cgi_url(@board, @topic, "9")
      assert_response :success

      get nichan_read_cgi_url(@board, @topic, "10-")
      assert_response :success

      get nichan_read_cgi_url(@board, @topic, "10-20")
      assert_response :success

      get nichan_read_cgi_url(@board, @topic, "l10")
      assert_response :success

      get nichan_read_cgi_url(@board, @topic, "l10n")
      assert_response :success
    end

    # test "should get bbs_cgi" do
      # post  '/test/bbs.cgi',                        to: 'nichan#bbs_cgi',     as: :nichan_bbs_cgi
    #   get nichan_bbs_cgi_url
    #   assert_response :success
    # end

  end
end
