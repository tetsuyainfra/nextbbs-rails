require "test_helper"

module Nextbbs
  class BoardStateMachineTest < ActiveSupport::TestCase
    class MockKlass < ActiveRecord::Base
      attribute :owner_id
      enum status: {
             removed: -1,       # 削除済み(削除理由は別途保存)
             unpublished: 0,   # 表示を取り下げ
             published: 1,     # 表示
           }
      include BoardStateMachine
    end

    def setup
      MockKlass.connection.create_table :nextbbs_mock_klasses, force: true do |t|
        t.bigint :owner_id
        t.integer :status
      end
      @user = users(:one)
      # @admin = users(:admin) # TODO: ADMINの実装
    end

    test "InittialStateが設定されている" do
      m = MockKlass.new(owner_id: @user.id)
      m.save!

      assert_equal m.status, "unpublished"
      m.save!
    end

    test "すべてのステートへ遷移できる" do
      m = MockKlass.create(owner_id: @user.id)
      assert_raises { m.publish() } # 引数チェック
      m.publish(@user)
      assert_raises { m.unpublish() }
      m.unpublish(@user)

      assert_equal m.status, "unpublished"
      assert_raises { m.remove() }
      m.remove(@user)

      m.published!
      assert_equal m.status, "published"
      assert_raises { m.remove() }
      m.remove(@user)

      # TODO: ADMINの実装
      # m.published!
      # assert m.status == published
      # m.remove(@admin)
    end
  end
end

# MEMO
# もしDB毎にテストを切り替えるならこれが参考になる
# rails/activerecord/test/cases/adapters/postgresql/enum_test.rb
# PostgreSQLTestCaseV
