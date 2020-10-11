module Nextbbs
  class Form::Board < Form::Base
    class_attribute :allowed_statuses
    attr_accessor :owner, :title, :name, :description, :status

    validates :owner, presence: true
    validates :name, presence: true
    validates :title, presence: true
    validates :status, presence: true

    def initialize(params = {})
      super params
      # title = params[:title].presence || "掲示板のタイトル"
      # description = params[:description].presence || "掲示板の説明文\n複数行可能"
    end

    def save
      raise ActiveRecord::RecordInvalid if invalid?
      ActiveRecord::Base.transaction do
        board = Nextbbs::Board.new(owner: owner,
                                   name: name,
                                   title: title,
                                   description: description, status: status)
        board.save
      end
    end

    # def update_attributes
    # end
  end

  Form::Board.allowed_statuses = Board.statuses.slice(:published, :unpublished)
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
