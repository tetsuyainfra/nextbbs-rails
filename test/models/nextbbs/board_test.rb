# == Schema Information
#
# Table name: nextbbs_boards
#
#  id             :bigint           not null, primary key
#  comments_count :integer          default(0), not null
#  description    :text
#  hash_token     :string
#  name           :string
#  status         :integer          not null
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :bigint           not null
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#

require "test_helper"

module Nextbbs
  class BoardTest < ActiveSupport::TestCase
    def setup
      @user = ::User.new(
        email: "example@example.com",
        password: "password"
      )
      @user.save!
      @board = Board.new(
        name: "testboard",
        title: "test",
        description: "",
        status: Board.statuses[:published],
        owner: @user,
      )
      @board.save!
    end

    test "OwnerからUserをたどれる" do
      board = Board.find(@board.id)
      assert_equal board.owner_id, @user.id
      assert_equal board.owner, @user
    end

    test "英語から始まる名前を保存できる" do
      @board.name = "abcd"
      assert @board.save

      @board.name = "abc0"
      assert @board.save

      @board.name = "abc_"
      assert @board.save
    end

    test "数字|記号から始まる英語の名前はエラー" do
      @board.name = "0abc"
      assert_not @board.save

      @board.name = "_abc"
      assert_not @board.save

      @board.name = "%abc"
      assert_not @board.save
    end

    test "記号を含む名前はエラー" do
      @board.name = "abcd\n"
      assert_not @board.save

      @board.name = "abcd+"
      assert_not @board.save

      @board.name = "abcd%"
      assert_not @board.save
    end

    test "英語以外の名前はエラー" do
      @board.name = "testあいうえお"
      assert_not @board.save
    end

    test "タイトルには改行を含むことはできない" do
      @board.title = "test\ntitle"
      # エラーが出るはず
      assert_not @board.valid?
      assert_not @board.save
      assert_raises(ActiveRecord::RecordInvalid) { @board.save! }
      assert_not_empty @board.errors[:title]

      @board.title = "test title"
      assert @board.valid?
      assert @board.save
    end

    test "タイトルにはUTF-8を含むことができる" do
      @board.title = "あいうえお愛上夫"
      assert @board.save

      # China
      @board.title = "张 毅"
      assert @board.save

      # Korea
      @board.title = "김 재원"
      assert @board.save

      # Emoji
      @board.title = "🏀😏😐😑"
      assert @board.save
    end

    test "タイトルの最大文字数は0以上64文字未満" do
      # Title length is 0 < len(str)  <= 32
      # OK Pattern
      @board.title = "あ" * 63
      assert @board.save
      ## China
      @board.title = "张" * 63
      assert @board.save
      ## Korea
      @board.title = "김" * 63
      assert @board.save
      ## Emoji
      @board.title = "🏀" * 63
      assert @board.save

      # False Pattern
      @board.title = ""
      assert_not @board.save

      @board.title = "あ" * 64
      assert_not @board.save
      ## China
      @board.title = "张" * 64
      assert_not @board.save
      ## Korea
      @board.title = "김" * 64
      assert_not @board.save
      ## Emoji
      @board.title = "🏀" * 64
      assert_not @board.save
    end

    test "説明文の最大文字数は0から1024文字未満" do
      # description length is 0 <= len(str)  <= 1024
      # OK Pattern
      @board.description = ""
      assert @board.save
      @board.description = "あ" * 1023
      assert @board.save

      # False Pattern
      @board.description = "🏀" * 1024
      assert_not @board.save
    end

    test "statusは次の値を取りうる" do
      @board.status = Board.statuses[:published]
      assert @board.save

      @board.status = Board.statuses[:unpublished]
      assert @board.save

      @board.status = Board.statuses[:deleted]
      assert @board.save
    end

    test "statusは指定値以外はエラーを出す" do
      assert_raises(ArgumentError){
        @board.status = :impossible_value
      }
    end

    test "hash_tokeにはデフォルトで値が入る" do
      assert_not_empty @board.hash_token
    end

  end
end
