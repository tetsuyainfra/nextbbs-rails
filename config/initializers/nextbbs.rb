Nextbbs.configure do |config|
  # config.bbs_name = "Nextbbs サンプル掲示板"
  # config.compatible_2ch = true
  # config.auto_create_board = false
  # you should change this
  # "rake secrete" will generate good hash likely follow
  config.board_secret_hash = "4d32a33bd508049da72e8d49b5b7ed1bcb0f4d61b2e7c38b893743602caf2183e16b668329df7242743c34cf65cbffc804bc7d8e81cc0b838b931c5e87b885a1"
  config.owner_model = "User"

  # config.current_user_method do
  #   current_user
  # end

  # config.authenticate_with do
  #   authenticate_user!
  # end

  # config.authorize_with do
  #   redirect_to root_path unless warden.user.is_admin?
  # end

  config.max_boards_count = 5
  # config.quota_board_within_limit do
  #   unless owner.nextbbs_boards.count < config.max_boards_count
  #     errors.add(:base, "boards count limit: #{config.max_boards_count}")
  #   end
  # end
end
