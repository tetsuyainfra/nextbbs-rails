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

    ################################################################################
    # /board/[:board_id]/topics
    # Guestでトピック一覧の表示をしても問題ない
    test "should get index" do
      get board_topics_url(@board)
      assert_response :success
    end
    test "should get index with login" do
      log_in(@user)
      get board_topics_url(@board)
      assert_response :success
    end

    ################################################################################
    # /board/[:board_id]/topics/new
    # Guestでトピック作成ページを表示できる
    test "should get new" do
      get new_board_topic_url(@board)
      assert_response :success
    end
    test "should get new with login" do
      log_in(@user)
      get new_board_topic_url(@board)
      assert_response :success
    end
    # 作成画面
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

    ################################################################################
    # CREATE /board/[:board_id]/topics
    # Guestでトピックの作成アクション
    test "should create topic with comments with no login" do
      assert_difference("Topic.count") do
        assert_difference("Comment.count") do
          post board_topics_url(@board), params: form_params
        end
      end

      assert_redirected_to board_topics_url(@board)
      # TODO: ownerの確認
    end
    # Ownerでトピックの作成
    test "should create topic with comments with login" do
      assert_difference("Topic.count") do
        assert_difference("Comment.count") do
          post board_topics_url(@board), params: form_params
        end
      end

      assert_redirected_to board_topics_url(@board)
      # TODO: ownerの確認
    end
    # Other userでトピックの作成
    test "should create topic with comments with other login" do
      assert_difference("Topic.count") do
        assert_difference("Comment.count") do
          post board_topics_url(@board), params: form_params
        end
      end

      assert_redirected_to board_topics_url(@board)
      # TODO: ownerの確認
    end

    ################################################################################
    # POST /board/[:board_id]/topics/[:id]/edit
    # 編集画面
    # test "should get edit" do
    #   get edit_board_topic_url(@board, @topic)
    #   assert_redirected_to main_app.new_user_session_path
    # end
    # test "should get edit with login" do
    #   log_in(@user)
    #   get edit_board_topic_url(@board, @topic)
    #   assert_response :success
    # end

    ################################################################################
    # POST /board/[:board_id]/topics/[:id]/update
    # 編集操作
    # test "should update topic with login" do
    #   log_in(@user)
    #   patch board_topic_url(@board, @topic), params: { form_topic: { title: @topic.title } }
    #   assert_redirected_to board_topic_url(@board, @topic)
    # end
    # test "should redirect to update topic with no login" do
    #   patch board_topic_url(@board, @topic), params: { form_topic: { title: @topic.title } }
    #   assert_redirected_to main_app.new_user_session_path
    # end

    ################################################################################
    # DELETE /board/[:board_id]/topics/[:id]
    # 削除操作
    # Owner
    test "should destroy topic with login" do
      log_in(@user)
      assert_difference("Topic.count", -1) do
        assert_difference("Comment.count", -1) do
          delete board_topic_url(@board, @topic)
        end
      end

      assert_redirected_to board_topics_url(@board)
    end
    # Guest
    test "should redirect to destroy topic with no login" do
      assert_no_difference("Topic.count") do
        assert_no_difference("Comment.count") do
          delete board_topic_url(@board, @topic)
        end
      end

      assert_redirected_to main_app.new_user_session_path
    end
    # Other User
    test "should destroy topic with other login" do
      log_in(@other_user)
      assert_no_difference("Topic.count") do
        assert_no_difference("Comment.count") do
          delete board_topic_url(@board, @topic)
        end
      end

      assert_redirected_to board_url(@board)
    end

    # TODO: 権限がないトピックを削除

    ################################################################################
    # 追加テスト
    # POST /board/[:board_id]/topics
    #
    # [Owner] 非表示になっている掲示板でのトピック一覧の表示確認
    test "index should be hidden with unpublished board without owner" do
      # 非表示指定
      @board.update(status: :unpublished)

      # オーナーだと表示可能
      log_in(@board.owner)
      get board_topics_url(@board)
      assert_response :success

      # 別ユーザーだと表示不可
      assert_not_equal @board.owner, @other_user
      log_in(@other_user)
      get board_topics_url(@board)
      assert_response :missing

      # 非ログインだと表示できない
      log_out
      get board_topics_url(@board)
      assert_response :missing
    end

    ################################################################################
    # 追加テスト
    # POST /board/[:board_id]/topics/[:id]
    #
    # [Owner] 非表示になっている掲示板での個別トピックの表示確認
    # オーナーだといずれも表示可能
    test "each should be hidden with unpublished board without owner" do
      # 非表示指定
      @board.update(status: :unpublished)

      # オーナーだと表示可能
      log_in(@board.owner)
      get board_topic_url(@board, @topic)
      assert_response :success

      # 別ユーザーだと表示不可
      assert_not_equal @board.owner, @other_user
      log_in(@other_user)
      get board_topic_url(@board, @topic)
      assert_response :missing

      # 非ログインだと表示できない
      log_out
      get board_topic_url(@board, @topic)
      assert_response :missing
    end

    private

    def form_params
      {
        form_topic: {
          title: "new topic",
          comments_attributes: {
            "1" => { name: "774", body: "body" },
          },
        },
      }
    end
  end
end
