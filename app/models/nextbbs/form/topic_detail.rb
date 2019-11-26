
module Nextbbs

class Form::TopicDetail << Form::Base
  REGISTRABLE_ATTRIBUTES = %i(name corporation_id price)
  has_many :order_details, class_name: 'Form::OrderDetail'

  after_initialize { order_details.build unless self.persisted? || order_details.present? }
  before_validation :calculate_order_price

  def selectable_corporations
    Corporation.all
  end

  private

  def calculate_order_price
    order_details.each(&:calculate_order_detail_price)
    self.price = order_details.map(&:price).sum
  end
end

end