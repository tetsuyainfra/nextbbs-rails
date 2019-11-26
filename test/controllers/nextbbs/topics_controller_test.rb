require 'test_helper'

module Nextbbs
  class TopicsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @topic = nextbbs_topics(:one)
    end

    test "should data element equal 2" do
      # See test/fixtures/nextbbs/topics.yml
      assert_equal 2, Topic.count
    end

    test "should get index" do
      get topics_url
      assert_response :success
    end

    test "should get new" do
      get new_topic_url
      assert_response :success
    end

    test "should create topic with comments" do
      assert_difference('Topic.count') do
        # assert_difference('Comment.count') do
          post topics_url, params: {
            form_topic: {
               title: "new topic",
               comments_attributes: {
                 "1" => { name: "774", body: "body" }
               }
            }
          }
        # end
      end

      assert_redirected_to topics_url
    end

    test "should show topic" do
      get topic_url(@topic)
      assert_response :success
    end

    test "should get edit" do
      get edit_topic_url(@topic)
      assert_response :success
    end

    test "should update topic" do
      patch topic_url(@topic), params: { form_topic: { title: @topic.title } }
      assert_redirected_to topic_url(@topic)
    end

    # MEMO: TODO
    test "should destroy topic" do
      assert_difference('Topic.count', -1) do
        delete topic_url(@topic)
      end

      assert_redirected_to topics_url
    end
  end
end
