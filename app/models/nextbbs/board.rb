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

module Nextbbs
  class Board < ApplicationRecord
    has_many :topics, dependent: :destroy

    enum status: {
      deleted: -1,       # 削除済み(削除理由は別途保存)
      unpublished: 0,   # 表示を取り下げ
      published: 1,     # 表示
    }

    attribute :hash_token, :string, default: SecureRandom.hex(8)

    belongs_to :owner, class_name: Nextbbs.config.owner_model

    validates :name,
              format: {
                with: /\A[a-zA-Z][a-zA-Z0-9_]+\z/,
                message: "半角英字から始まる半角英数文字列と_(アンダーバー)が使えます",
              },
              length: { in: 4..32 }
    validates :title, format: { with: /\A[^\r\n]+\z/ }, length: { in: 1..63 }
    validates :description, length: { in: 0..1023 }
  end
end
