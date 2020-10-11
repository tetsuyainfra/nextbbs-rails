module Nextbbs
  module BoardsHelper
    # ユーザが新規ボードを作成可能か確認
    def user_can_create_new_board?
      _current_user.nextbbs_boards.count < Nextbbs.config.user_max_board_num
    end
  end
end
