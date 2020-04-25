require "test_helper"

module Nextbbs
  class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @board = nextbbs_boards(:one)
      @topic = nextbbs_topics(:one)
      @comments = @topic.comments
      @comment = @topic.comments.sorted.first
    end

    # 個別レス表示
    test "should not show comment" do
      get comment_url(@comment)
      # 現在はそんざいしない
      assert_response :success
    end

    # コメントの投稿(単発での投稿用フォームは存在しない)
    # TODO: ないことのチェックってどうする？
    # test "should not get new" do
    #   # get new_comment_url
    #   get File.join(comments_url, "new")
    #   assert_response :missing
    # end

    # Board -> Topic とたどってコメントを作る
    test "should create comment" do
      assert_difference("Comment.count") do
        post comments_url,
             params: {
               form_comment: {
                 body: @comment.body,
                 name: @comment.name,
                 topic_id: @comment.topic_id,
               },
             }
        # redirect先はtopicの一覧
        assert_redirected_to board_topic_url(@comment.topic.board, @comment.topic)
      end
    end

    # Topicを作るのでtopic_id含がまれていなければ作成しない
    test "must not create comment to have not topic_id" do
      assert_no_difference("Comment.count") do
        post comments_url,
             params: {
               form_comment: {
                 body: @comment.body, name: @comment.name,
               },
             }
        # redirect先はroot_url
        assert_redirected_to root_url
      end
    end

    test "HashIDの生成(Boardに設定が関連付けられる)" do
      # created_atとは別のタイミングでDateを生成しているため時刻が変わるタイミングで
      # ずれが生じる可能性がある
      assert_difference("Comment.count") do
        post comments_url,
             params: {
               form_comment: {
                 body: "hash test",
                 name: "hash testname",
                 topic_id: @topic.id,
               },
             }
      end
      last_comment = Comment.sorted.last
      assert_equal last_comment.body, "hash test"
      assert_equal last_comment.name, "hash testname"
      assert_equal last_comment.topic_id, @topic.id

      ipaddr = last_comment.ip
      date = last_comment.created_at.to_date
      hash_token = last_comment.topic.board.hash_token
      hashid = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        "#{hash_token}#{date.to_s}", ipaddr.to_s
      )[0..8]

      assert_equal last_comment.hashid, hashid
    end

    # 連続書き込みの制限(Boardに設定が関連付けられる)

    # 制限ワード時の書き込み制限(Boardに設定が関連付けられる)

    # BAN制限時の書き込み制限(Boardに設定が関連付けられる)



    # レスの書き換えURL(ログインユーザーのみ)
    # test "should get edit" do
    #   get edit_comment_url(@comment)
    #   assert_response :success
    # end

    # レスの書き換え(ログインユーザーのみ)
    # test "should update comment" do
    #   patch comment_url(@comment), params: { comment: { body: @comment.body, name: @comment.name, topic_id: @comment.topic_id } }
    #   assert_redirected_to comment_url(@comment)
    # end

    # レスの状態変更(削除(板オーナー))
    # レスの状態変更(削除(板ボランティア))
    # レスの状態変更(削除(運営))
    # test "should destroy comment" do
    #   assert_difference('Comment.count', -1) do
    #     delete comment_url(@comment)
    #   end

    #   assert_redirected_to comments_url
    # end
  end
end
