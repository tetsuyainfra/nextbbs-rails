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

    ################################################################################
    # 板一覧の表示
    # Guestで表示
    test "should get Board index" do
      get boards_url
      assert_response :success
    end
    # ログインしていても表示可能
    test "should get Board index with login" do
      log_in(@user)
      get boards_url
      assert_response :success
    end

    ################################################################################
    # /boards/new
    # Guestで板作成画面の表示をするとリダイレクトされる
    test "should get new Board with no login" do
      get new_board_url
      assert_redirected_to main_app.new_user_session_path
    end
    # ログインしていると板作成画面の表示はできる
    test "should get new Board with login" do
      log_in(@user)
      get new_board_url
      assert_response :success
    end

    ################################################################################
    # /boards/create
    #
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

      assert_redirected_to yours_boards_url
    end

    ################################################################################
    # /boards
    # With Guest
    # [Guest] 板の表示
    test "publish status should show board" do
      get board_url(@board)
      assert_response :success
    end
    # [Guest] unpublishだと404になる
    test "unpublish status should hidden board" do
      @board.status = :unpublished
      @board.save!
      get board_url(@board)
      assert_response :missing
    end
    # [Guest] deleteだと404になる
    test "delete status should hidden board" do
      @board.status = :removed
      @board.save!
      get board_url(@board)
      assert_response :missing
    end

    ################################################################################
    # /board/[:board_id]/control
    #
    # コントロール画面の表示
    test "should show control board with login" do
      log_in(@user)
      get control_board_url(@board)
      assert_response :success
    end
    # 非ログイン状態で コントロール画面を表示するとログイン画面にリダイレクトされる
    test "guest should be redirect to show control board" do
      get control_board_url(@board)
      assert_redirected_to main_app.new_user_session_path
    end
    # 非オーナーでコントロール画面を開くとリダイレクトされる
    test "other owner should be redirect to show control board" do
      log_in(@other_user)
      get control_board_url(@board)
      assert_redirected_to board_url(@board)
    end

    ################################################################################
    # /board/[:board_id]/edit
    #
    # 板情報の変更を開く
    test "should get edit with login" do
      log_in(@user)
      get edit_board_url(@board)
      assert_response :success
    end
    # ログインしていないと板情報の変更を開くとリダイレクトされる
    test "should redirect to get edit with no login" do
      get edit_board_url(@board)
      assert_redirected_to main_app.new_user_session_path
    end
    # 非オーナーで板情報の変更を開くとリダイレクトされる
    test "should redirect to get edit with other login" do
      log_in(@other_user)
      get edit_board_url(@board)
      assert_redirected_to board_url(@board)
    end

    ################################################################################
    # PATCH /board/[:board_id]/update
    #
    # 板情報の変更
    test "should update board with login" do
      log_in(@user)
      patch board_url(@board), params: { board: { title: @board.title } }
      assert_redirected_to board_url(@board)
    end
    # ログインしていないと板情報の変更をするとリダイレクトされる
    test "should redirect with no login to update board" do
      patch board_url(@board), params: { board: { title: @board.title } }
      assert_redirected_to main_app.new_user_session_path
    end

    # 非オーナーで板情報の変更をするとリダイレクトされる
    test "should redirect with other login to update board" do
      log_in(@other_user)
      patch board_url(@board), params: { board: { title: @board.title } }
      assert_redirected_to board_url(@board)
    end

    ################################################################################
    # POST /board/[:board_id]/destory
    #
    # 板の削除
    # TODO: hash_tokenが入力されてないときのエラー処理がない
    test "should destroy board with login" do
      log_in(@user)
      assert_difference("Board.count", -1) do
        delete board_url(@board), params: { board: { destroy_seed: @board.hash_token } }
        assert_redirected_to yours_boards_url
      end

      get board_url(@board)
      assert_response :missing
    end
    # ログインしていない時に板の削除をするとリダイレクトされる
    # hash_tokenが漏れたとする
    test "should redirect to destroy board with no login" do
      assert_no_difference("Board.count") do
        delete board_url(@board), params: { board: { destroy_seed: @board.hash_token } }
        assert_redirected_to main_app.new_user_session_path
      end
    end
    # 別ユーザーが板の削除をするとリダイレクトされる
    # hash_tokenが漏れたとする
    test "should redirect to destroy board with other login" do
      log_in(@other_user)
      assert_no_difference("Board.count") do
        delete board_url(@board), params: { board: { destroy_seed: @board.hash_token } }
        assert_redirected_to board_url(@board)
      end
    end

    ################################################################################
    # 追加テスト
    # POST /board/[:board_id]
    #
    # [Owner] 板の表示
    # オーナーだといずれも表示可能
    test "should be show or hidden other status with login" do
      log_in(@board.owner)

      @board.update(status: :unpublished)
      get board_url(@board)
      assert_response :success

      @board.update(status: :removed)
      get board_url(@board)
      assert_response :missing
    end

    # 別ユーザーだといずれも表示不可
    test "should be show or hidden other status with other login" do
      log_in(@other_user)

      @board.update(status: :unpublished)
      get board_url(@board)
      assert_response :missing

      @board.update(status: :removed)
      get board_url(@board)
      assert_response :missing
    end

    # 別ユーザーだといずれも表示不可
    test "should be show or hidden other status with no login" do
      @board.update(status: :unpublished)
      get board_url(@board)
      assert_response :missing

      @board.update(status: :removed)
      get board_url(@board)
      assert_response :missing
    end

    ################################################################################
    # 追加テスト
    # POST /board/[:board_id]/create
    #
    # 設定数以上の板を作成できない

    private

    def board_params
      {
        board: {
          name: "testcreate",
          title: "test board",
          description: "",
          status: :published,
          owner: @user,
        },
      }
    end
  end
end
