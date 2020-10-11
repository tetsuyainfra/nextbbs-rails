
require 'test_helper'

module Nextbbs
  class RoutingTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "Boards resource" do
      # 渡されたオプションは、渡されたパスの生成に使えるものであると主張する。
      # assert_generates '/photos/1', { controller: 'photos', action: 'show', id: '1' }

      # assert_generatesの逆方向のテスト
      # 渡されたパスのルーティングが正しく扱われ、(expected_optionsハッシュで渡された) 解析オプションがパスと一致したことを主張する。
      # {controller: ...} が expected_options相当
      assert_recognizes({ controller: 'nextbbs/boards', action: 'show', id: '1' }, '/nextbbs/boards/1')

      # *_generates, _recognizesの両方からチェックする
      # assert_routing({ path: 'photos', method: :post }, { controller: 'photos', action: 'create' })
    end

    test "Topics resource" do
      assert_recognizes({ controller: 'nextbbs/topics', action: 'show', board_id: '2', id: '22' }, '/nextbbs/boards/2/topics/22')
    end

    test "Comments resource" do
      assert_recognizes({ controller: 'nextbbs/comments', action: 'show', id: '3' }, '/nextbbs/comments/3')
    end

  end
end
