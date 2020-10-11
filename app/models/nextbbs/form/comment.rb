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
#  sequential_id :integer
#  topic_id      :bigint
#
# Indexes
#
#  index_nextbbs_comments_on_topic_id  (topic_id)
#
# Foreign Keys
#
#  fk_rails_...  (topic_id => nextbbs_topics.id)
#


module Nextbbs

class Form::Comment < Comment
  REGISTRABLE_ATTRIBUTES = %i(name email, body)
  # attribute :name
  # attribute :email
  # attribute :body

  # def initialize(attributes = {})
  #   super attributes
  # end
end

end
