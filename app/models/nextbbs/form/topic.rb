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

module Nextbbs
  class Form::Topic < Topic
    REGISTRABLE_ATTRIBUTES = %i(board_id title)
    attribute :board_id, :integer
    attribute :title, :string
    has_many :comments, class_name: "Form::Comment"

    # def initialize(attirbutes={})
    #   super attirbutes
    # end
  end
end
