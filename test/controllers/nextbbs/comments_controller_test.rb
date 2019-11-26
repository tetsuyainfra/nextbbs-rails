require 'test_helper'

module Nextbbs
  class CommentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @topic = nextbbs_topics(:one)
      @comments = @topic.comments
      @comment = nextbbs_comments(:one_1)
    end

    test "should get index" do
      get topic_comments_url(@topic)
      assert_response :success

      assert_select 'title',  @topic.title
    end

    # test "should get new" do
    #   get new_comment_url
    #   assert_response :success
    # end

    # test "should create comment" do
    #   assert_difference('Comment.count') do
    #     post comments_url, params: { comment: { body: @comment.body, name: @comment.name, topic_id: @comment.topic_id } }
    #   end

    #   assert_redirected_to comment_url(Comment.last)
    # end

    # test "should show comment" do
    #   get comment_url(@comment)
    #   assert_response :success
    # end

    # test "should get edit" do
    #   get edit_comment_url(@comment)
    #   assert_response :success
    # end

    # test "should update comment" do
    #   patch comment_url(@comment), params: { comment: { body: @comment.body, name: @comment.name, topic_id: @comment.topic_id } }
    #   assert_redirected_to comment_url(@comment)
    # end

    # test "should destroy comment" do
    #   assert_difference('Comment.count', -1) do
    #     delete comment_url(@comment)
    #   end

    #   assert_redirected_to comments_url
    # end
  end
end
