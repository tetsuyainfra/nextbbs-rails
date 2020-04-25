require "test_helper"

module Nextbbs
  # TODO:
  # - errorバージョンのパラメータの試験も必要
  # - XHR経由の操作の試験も必要
  #
  class TopicsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Warden::Test::Helpers

    setup do
      @user = users(:one)
      @board = nextbbs_boards(:one)
      @topic = nextbbs_topics(:one)

      @other_user = User.new email: "john@example.com", password: "12345678"
      @other_user.save!
    end

    test "should get index" do
      get board_topics_url(@board)
      assert_response :success
    end
    test "should get index with login" do
      log_in(@user)
      get board_topics_url(@board)
      assert_response :success
    end


    test "should get new" do
      get new_board_topic_url(@board)
      assert_response :success
    end
    test "should get new with login" do
      log_in(@user)
      get new_board_topic_url(@board)
      assert_response :success
    end


    test "should create topic with comments with no login" do
      assert_difference("Topic.count") do
        assert_difference("Comment.count") do
          post board_topics_url(@board), params: form_params
        end
      end

      assert_redirected_to board_topics_url(@board)
    end
    test "should create topic with comments with login" do
      assert_difference("Topic.count") do
        assert_difference("Comment.count") do
          post board_topics_url(@board), params: form_params
        end
      end

      assert_redirected_to board_topics_url(@board)
    end


    test "should show topic" do
      get board_topic_url(@board, @topic)

      assert_response :success
      assert_select "title", "#{@topic.title} | #{@board.title}"
    end
    test "should show topic with login" do
      log_in(@user)
      get board_topic_url(@board, @topic)
      assert_response :success
      assert_select "title", "#{@topic.title} | #{@board.title}"
    end


    test "should get edit" do
      get edit_board_topic_url(@board, @topic)
      assert_redirected_to main_app.new_user_session_path
    end
    test "should get edit with login" do
      log_in(@user)
      get edit_board_topic_url(@board, @topic)
      assert_response :success
    end

    test "should update topic with login" do
      log_in(@user)
      patch board_topic_url(@board, @topic), params: { form_topic: { title: @topic.title } }
      assert_redirected_to board_topic_url(@board, @topic)
    end
    test "should redirect to update topic with no login" do
      patch board_topic_url(@board, @topic), params: { form_topic: { title: @topic.title } }
      assert_redirected_to main_app.new_user_session_path
    end

    test "should destroy topic with login" do
      log_in(@user)
      assert_difference("Topic.count", -1) do
        assert_difference("Comment.count", -1) do
          delete board_topic_url(@board, @topic)
        end
      end

      assert_redirected_to board_topics_url(@board)
    end
    test "should redirect to destroy topic with no login" do
      assert_no_difference("Topic.count") do
        assert_no_difference("Comment.count") do
          delete board_topic_url(@board, @topic)
        end
      end

      assert_redirected_to main_app.new_user_session_path
    end
    test "should destroy topic with other login" do
      log_in(@other_user)
      assert_no_difference("Topic.count") do
        assert_no_difference("Comment.count") do
          delete board_topic_url(@board, @topic)
        end
      end

      assert_redirected_to boards_url
    end

    # TODO: 権限がないトピックを削除

    private

    def form_params
      {
        form_topic: {
          title: "new topic",
          comments_attributes: {
            "1" => { name: "774", body: "body" },
          },
        }
      }
    end
  end
end
