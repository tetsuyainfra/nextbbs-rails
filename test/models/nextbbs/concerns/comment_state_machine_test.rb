require "test_helper"

module Nextbbs
  class CommentStateMachineTest < ActiveSupport::TestCase
    class BoardKlass < ActiveRecord::Base
      attribute :owner_id
      enum status: {
             removed: -1,       # 削除済み(削除理由は別途保存)
             unpublished: 0,   # 表示を取り下げ
             published: 1,     # 表示
           }
      has_many :topics, class_name: "TopicKlass"
      include BoardStateMachine
    end

    class TopicKlass < ActiveRecord::Base
      attribute :owner_id
      enum status: {
             removed: -1,       # 削除済み(削除理由は別途保存)
             unpublished: 0,   # 表示を取り下げ
             published: 1,     # 表示
             archived: 2,     # 表示
           }
      belongs_to :board, class_name: "BoardKlass"
      has_many :comments, class_name: "CommentKlass"
      include TopicStateMachine
    end

    class CommentKlass < ActiveRecord::Base
      enum status: {
             removed: -1,      # 削除済み(削除理由は別途保存)
             submitted: 0,     # 送信済み(だが非表示)
             published: 1,     # 表示
             rejected: 2,      # 拒否(だが非表示)
           }
      belongs_to :topic, class_name: "TopicKlass"
      include CommentStateMachine
    end

    def setup
      BoardKlass.connection.create_table :nextbbs_board_klasses, force: true do |t|
        t.bigint :owner_id
        t.integer :status
      end
      TopicKlass.connection.create_table :nextbbs_topic_klasses, force: true do |t|
        t.bigint :board_id
        t.bigint :owner_id
        t.integer :status
      end
      CommentKlass.connection.create_table :nextbbs_comment_klasses, force: true do |t|
        t.bigint :topic_id
        t.bigint :owner_id, null: true
        t.integer :status
      end
      @user = users(:one)
      @topic_board_owner = @user
      # @admin = users(:admin) # TODO: ADMINの実装
      @board = BoardKlass.new(owner_id: @user.id)
      @topic = TopicKlass.new(owner_id: @user.id, board: @board)

      @other_user = users(:two)
    end

    test "InittialStateが設定されている" do
      c = CommentKlass.create(owner_id: @user.id, topic: @topic)
      assert_equal c.status, "submitted"
    end

    test "コンストラクタで値を設定できる" do
      c = CommentKlass.create(owner_id: @user.id, topic: @topic,
                              status: "submitted")
      assert_equal c.status, "submitted"
    end
    test "すべてのステートへ遷移できる" do
      c = CommentKlass.create(owner_id: @topic_board_owner.id, topic: @topic,
                              status: "submitted")
      c.reject(@topic_board_owner)
      c.save!
      c.submit(@topic_board_owner)
      c.save!
      c.publish(@topic_board_owner)
      c.save!
      assert_raises { c.submit() }

      c = CommentKlass.create(owner_id: @topic_board_owner.id, topic: @topic,
                              status: "submitted")
      c.remove(@topic_board_owner)
      c = CommentKlass.create(owner_id: @topic_board_owner.id, topic: @topic,
                              status: "published")
      c.remove(@topic_board_owner)
      c = CommentKlass.create(owner_id: @topic_board_owner.id, topic: @topic,
                              status: "rejected")
      c.remove(@topic_board_owner)
    end

    test "その他のユーザ操作が禁止されているか" do
      c = CommentKlass.create(owner_id: @other_user.id, topic: @topic,
                              status: "submitted")
      # 掲示板オーナー以外がコメント状態変更できない
      assert_raises { c.publish(@other_user) }

      # 削除
      c = CommentKlass.create(owner_id: @topic_board_owner.id, topic: @topic,
                              status: "submitted")
      assert_raises { c.remove(@other_user) }
      c = CommentKlass.create(owner_id: @topic_board_owner.id, topic: @topic,
                              status: "published")
      assert_raises { c.remove(@other_user) }
      c = CommentKlass.create(owner_id: @topic_board_owner.id, topic: @topic,
                              status: "rejected")
      assert_raises { c.remove(@other_user) }
    end

    test "想定されている操作" do
      c = CommentKlass.create(owner_id: nil, topic: @topic,
                              status: "submitted")
      c.reject(@topic_board_owner)
      c.save!

      c = CommentKlass.create(owner_id: @other_user.id, topic: @topic,
                              status: "submitted")
      c.reject(@topic_board_owner)
      c.save!
      c.submit(@other_user)
      c.save!
      c.publish(@topic_board_owner)
      c.save!
      c.remove(@topic_board_owner)
      c.save!
    end
  end
end

# MEMO
# もしDB毎にテストを切り替えるならこれが参考になる
# rails/activerecord/test/cases/adapters/postgresql/enum_test.rb
# PostgreSQLTestCaseV
