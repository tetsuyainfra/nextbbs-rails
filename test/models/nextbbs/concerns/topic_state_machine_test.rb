require "test_helper"

module Nextbbs
  class TopicStateMachineTest < ActiveSupport::TestCase
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
      include TopicStateMachine
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
      @user = users(:one)
      # @admin = users(:admin) # TODO: ADMINの実装
      @board = BoardKlass.create(owner_id: @user.id, status: "published")
    end

    test "InittialStateが設定されている" do
      topic = TopicKlass.create(owner_id: @user.id, board: @board)
      assert_equal topic.status, "unpublished"
    end

    test "コンストラクタで値を設定できる" do
      topic = TopicKlass.create(owner_id: @user.id, board: @board,
                                status: "published")
      assert_equal topic.status, "published"
    end

    test "すべてのステートへ遷移できる" do
      topic = TopicKlass.create(owner_id: @user.id, board: @board)
      topic.publish(@user)
      topic.save!
      topic.unpublish(@user)
      topic.save!
      topic.publish(@user)
      topic.save!
      topic.archive()
      topic.save!

      topic = TopicKlass.create(owner_id: @user.id, board: @board,
                                status: "published")
      topic.unpublish(@user)
      topic.save!
      assert_raises { topic.archive() }

      topic = TopicKlass.create(owner_id: @user.id, board: @board,
                                status: "published")
      topic.remove(@user)
      topic = TopicKlass.create(owner_id: @user.id, board: @board,
                                status: "unpublished")
      topic.remove(@user)
      topic = TopicKlass.create(owner_id: @user.id, board: @board,
                                status: "archived")
      topic.remove(@user)
    end
  end
end

# MEMO
# もしDB毎にテストを切り替えるならこれが参考になる
# rails/activerecord/test/cases/adapters/postgresql/enum_test.rb
# PostgreSQLTestCaseV
