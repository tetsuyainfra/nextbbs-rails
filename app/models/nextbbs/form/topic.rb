
module Nextbbs

class Form::Topic < Topic
  DEFAULT_ITEM_COUNT = 3
  REGISTRABLE_ATTRIBUTES = %i(title)
  attr_accessor :title
  has_many :comments, class_name: 'Form::Comment'

  after_initialize { DEFAULT_ITEM_COUNT.times.map{ comments.build } unless self.persisted? || comments.present? }
end

end