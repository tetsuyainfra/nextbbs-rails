# == Schema Information
#
# Table name: nextbbs_topics
#
#  id             :bigint           not null, primary key
#  comments_count :integer          default(0), not null
#  status         :integer          not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  board_id       :bigint
#  owner_id       :bigint           not null
#
# Indexes
#
#  index_nextbbs_topics_on_board_id  (board_id)
#
# Foreign Keys
#
#  fk_rails_...  (board_id => nextbbs_boards.id)
#

require "test_helper"

module Nextbbs
  class TopicTest < ActiveSupport::TestCase
    def setup
      @user = users(:one)
      @board = Board.new(
        name: "testboard",
        title: "test",
        description: "",
        status: Board.statuses[:published],
        owner: @user,
      )
      @board.save!
      @topic = @board.topics.build(
        title: "test",
        status: Topic.statuses[:published],
        owner: @user,
      )
      @topic.save!
    end

    test "タイトルには改行を含むことはできない" do
      @topic.title = "test\ntitle"
      # エラーが出るはず
      assert_not @topic.valid?
      assert_not_empty @topic.errors[:title]

      @topic.title = "test title"
      assert @topic.valid?
      assert @topic.save
    end

    test "タイトルにはutf-8を含むことができる" do
      @topic.title = "あいうえお愛上夫"
      assert @topic.save

      # china
      @topic.title = "张 毅"
      assert @topic.save

      # korea
      @topic.title = "김 재원"
      assert @topic.save

      # emoji
      @topic.title = "🏀😏😐😑"
      assert @topic.save
    end

    MAX_CHARS = 63
    test "タイトルの最大文字数は0以上#{MAX_CHARS}以内" do

      # title length is 0 < len(str)  <= 64
      # ok pattern
      @topic.title = "あ" * MAX_CHARS
      assert @topic.save
      ## china
      @topic.title = "张" * MAX_CHARS
      assert @topic.save
      ## korea
      @topic.title = "김" * MAX_CHARS
      assert @topic.save
      ## emoji
      @topic.title = "🏀" * MAX_CHARS
      assert @topic.save

      # false pattern
      @topic.title = ""
      assert_not @topic.save

      @topic.title = "あ" * (MAX_CHARS + 1)
      assert_not @topic.save
      ## china
      @topic.title = "张" * (MAX_CHARS + 1)
      assert_not @topic.save
      ## korea
      @topic.title = "김" * (MAX_CHARS + 1)
      assert_not @topic.save
      ## emoji
      @topic.title = "🏀" * (MAX_CHARS + 1)
      assert_not @topic.save
    end

    test "コメントと同時に保存できる" do
      param = {
        board_id: @board.id,
        title: "test",
        owner: @board.owner,
        comments_attributes: [
          {
            body: "body",
            ip: "192.168.11.1",
          },
        ],
      }
      @new_topic = Topic.new param
      @new_topic.status = :published
      @new_topic.comments.each { |c| c.status = :published }
      assert @new_topic.save
    end

    test "statusは次の値を取りうる" do
      @topic.status = Topic.statuses[:published]
      assert @board.save

      @topic.status = Topic.statuses[:unpublished]
      assert @board.save

      @topic.status = Topic.statuses[:deleted]
      assert @board.save
    end

    test "statusは指定値以外はエラーを出す" do
      assert_raises(ArgumentError) {
        @topic.status = :impossible_value
      }
    end
  end
end
