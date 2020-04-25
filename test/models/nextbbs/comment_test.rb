# == Schema Information
#
# Table name: nextbbs_comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  email      :string
#  hashid     :string
#  hostname   :string
#  ip         :inet             not null
#  name       :string
#  status     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  owner_id   :bigint
#  topic_id   :bigint
#
# Indexes
#
#  index_nextbbs_comments_on_topic_id  (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => nextbbs_topics.id)
#

require 'test_helper'

module Nextbbs
  class CommentTest < ActiveSupport::TestCase
    def setup
      @user = users(:one)
      @board = Board.new(
        name: "testboard",
        title: "test",
        description: "",
        status: Board.statuses[:published],
        owner: @user
      )
      @board.save!
      @topic = @board.topics.build(
        title: "test",
        status: Topic.statuses[:published]
      )
      @topic.save!
      @comment = @topic.comments.build(
        body: "test",
        ip: "192.168.1.123",
        status: Comment.statuses[:published]
      )
      @comment.save!
    end

    test "コメントにはUserを追加できる" do
      @comment.owner = @user
      assert @comment.valid?

      @comment.owner_id = @user.id
      assert @comment.valid?
    end

    test "コメントにはnilでも良い" do
      @comment.owner = nil
      assert @comment.valid?
      @comment.owner_id = nil
      assert @comment.valid?
    end

    test "bodyは空白で保存できない" do
      @comment.body = ""
      assert @comment.invalid?
      @comment.body = " "
      assert @comment.invalid?
      @comment.body = "  " # 2char
      assert @comment.invalid?
      @comment.body = "　"
      assert @comment.invalid?
    end

    test "bodyには改行を含められる" do
      @comment.body = <<-"EOF"
      test
      test
      test
      EOF
      assert @comment.save!
    end

    test "emailはhoge@foobarの形式で無くてよい" do
      @comment.email = "email.dummy"
      assert @comment.valid?
      @comment.email = "sage"
      assert @comment.valid?
      @comment.email = "あいうえお"
      assert @comment.valid?
    end


    test "ipaddressにはIPv4,IPv6が入れられる" do
      @comment.ip = Faker::Internet.ip_v4_address
      assert @comment.valid?

      @comment.ip = Faker::Internet.ip_v6_address
      assert @comment.valid?
    end

    test "hostnameには文字列が入れられる" do
      @comment.ip = Faker::Internet.domain_name
      assert @comment.valid?
    end

    test "statusは次の値を取りうる" do
      @comment.status = Comment.statuses[:published]
      assert @comment.save

      @comment.status = Comment.statuses[:unpublished]
      assert @comment.save

      @comment.status = Comment.statuses[:pending]
      assert @comment.save

      @comment.status = Comment.statuses[:deleted]
      assert @comment.save
    end

    test "statusは指定値以外はエラーを出す" do
      assert_raises(ArgumentError){
        @comment.status = :impossible_value
      }
    end

    test "hashは値を入れられる" do
      @comment.hashid = "hogehoge"
      assert @comment.save
    end
    test "hashはnil/emptyでも良い" do
      @comment.hashid = nil
      assert @comment.save

      @comment.hashid = ""
      assert @comment.save
    end

  end
end
