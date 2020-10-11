module Nextbbs
  class Comment < ApplicationRecord
    belongs_to :topic
    acts_as_sequenced scope: :topic_id

    counter_culture [:topic, :board]
    counter_culture :topic

    enum status: {
      deleted: -1,    # 削除済み(削除理由は別途保存)
      unpublished: 0, # 表示を取り下げ # TODO: いらなくない？
      published: 1,   # 表示
      pending: 2,     # オーナーの承認待ち
    }

    belongs_to :owner, class_name: Nextbbs.config.owner_model, optional: true

    before_create :calc_hashid
    # MEMO: コメント書き換え機能がつくと変更の必要あり

    validates :body, presence: true, length: { minimum: 1 }
    scope :sorted, -> { order([:created_at, :id]) }

    def calc_hashid
      hash_token = topic.board.hash_token
      date = Time.zone.now.to_date
      self.hashid = OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new("sha256"),
        "#{hash_token}#{date.to_s}", ip.to_s
      )[0..8]
      self
    end
  end
end

# == Schema Information
#
# Table name: nextbbs_comments
#
#  id            :bigint           not null, primary key
#  body          :text
#  email         :string
#  hashid        :string
#  hostname      :string
#  ip            :inet             not null
#  name          :string
#  status        :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  owner_id      :bigint
#  sequential_id :integer          not null
#  topic_id      :bigint
#
# Indexes
#
#  index_nextbbs_comments_on_topic_id                    (topic_id)
#  index_nextbbs_comments_on_topic_id_and_sequential_id  (topic_id,sequential_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => nextbbs_topics.id)
#
