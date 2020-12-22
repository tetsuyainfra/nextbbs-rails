module Nextbbs
  class Board < ApplicationRecord
    include AASM
    MAX_BOARDS_COUNT = 5
    has_many :topics, dependent: :destroy

    enum status: {
      removed: -1,       # 削除済み(削除理由は別途保存)
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

    validate :boards_count_must_be_within_limit, on: :create

    def boards_count_must_be_within_limit
      unless owner.nextbbs_boards.count < Nextbbs.config.max_boards_count
        errors.add(:base, "boards count limit: #{Nextbbs.config.max_boards_count}")
      end
    end

    scope :published, -> { where(status: "published") }

    include BoardStateMachine
  end
end

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
