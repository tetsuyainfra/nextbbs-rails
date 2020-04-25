require "test_helper"

module Nextbbs
  class BoardsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include Warden::Test::Helpers

    setup do
      @other_user = User.new email: "john@example.com", password: "12345678"
      @other_user.save!

      @board = nextbbs_boards(:one)
      @user = @board.owner
    end

    test "should get Board index" do
      get boards_url
      assert_response :success
    end

    test "should get Board index with login" do
      log_in(@user)
      get boards_url
      assert_response :success
    end

    test "should get new Board with nologin" do
      get new_board_url
      assert_redirected_to main_app.new_user_session_path
    end

    test "should get new Board with login" do
      log_in(@user)
      get new_board_url
      assert_response :success
    end

    # 板の作成はログインしていないとリダイレクトされる
    test "should redirect to create board with no login" do
      assert_no_difference("Board.count") do
        post boards_url, params: board_params
        assert_redirected_to main_app.new_user_session_path
      end
    end

    # 板の作成 with login
    test "should create board with login" do
      assert_difference("Board.count", 1) do
        log_in(@user)
        post boards_url, params: board_params
      end

      assert_redirected_to board_url(Board.last)
    end

    # 板の表示
    test "should show board" do
      get board_url(@board)
      assert_response :success
    end

    # コントロール画面を表示するとリダイレクトされる
    test "should show control board" do
      get control_board_url(@board)
      assert_redirected_to main_app.new_user_session_path
    end

    # コントロール画面の表示
    test "should show control board with login" do
      log_in(@user)
      get control_board_url(@board)
      assert_response :success
    end

    # ログインしていないと板情報の変更を開くとリダイレクトされる
    test "should redirect to get edit with no login" do
      get edit_board_url(@board)
      assert_redirected_to main_app.new_user_session_path
    end

    # 板情報の変更を開く
    test "should get edit with login" do
      log_in(@user)
      get edit_board_url(@board)
      assert_response :success
    end

    # ログインしていないと板情報の変更をするとリダイレクトされる
    test "should redirect with no login to update board" do
      patch board_url(@board), params: { board: { title: @board.title, }, }
      assert_redirected_to main_app.new_user_session_path
    end

    # 板情報の変更
    test "should update board with login" do
      log_in(@user)
      patch board_url(@board), params: { board: { title: @board.title, }, }
      assert_redirected_to board_url(@board)
    end

    # 板の非表示
    test "should unpublished board with login" do
      log_in(@board.owner)
      patch board_url(@board), params: { board: { status: :unpublished, }, }
      assert_redirected_to board_url(@board)

      # オーナーだと表示可能
      log_in(@board.owner)
      get board_url(@board)
      assert_response :success

      # 別ユーザーだと表示不可
      log_in(@other_user)
      get board_url(@board)
      assert_response :missing

      # 非ログインだと表示できない
      log_out
      get board_url(@board)
      assert_response :missing
    end

    # ログインしていない時に板の削除をするとリダイレクトされる
    test "should redirect to destroy board with no login" do
      assert_no_difference("Board.count") do
        delete board_url(@board)
        assert_redirected_to main_app.new_user_session_path
      end
    end

    # 板の削除をするとリダイレクトされる
    test "should destroy board with login" do
      log_in(@user)
      assert_difference("Board.count", -1) do
        delete board_url(@board)
        assert_redirected_to boards_url
      end

      get board_url(@board)
      assert_response :missing
    end

    private

    def board_params
      {
        board: {
          name: "testcreate",
          title: "test board",
          description: "",
          status: :published,
          owner: @user
        },
      }
    end
  end
end
