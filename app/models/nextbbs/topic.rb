module Nextbbs
  class Topic < ApplicationRecord
    belongs_to :board
    belongs_to :owner, class_name: Nextbbs.config.owner_model

    has_many :comments, dependent: :delete_all
    accepts_nested_attributes_for :comments

    enum status: {
      deleted: -1,    # 削除済み(削除理由は別途保存)
      unpublished: 0, # 表示を取り下げ
      published: 1,   # 公開
      logged: 2,     # 過去ログ化
    }

    validates :title, format: { with: /\A[^\r\n]+\z/ }, length: { in: 1..63 }
  end
end

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
