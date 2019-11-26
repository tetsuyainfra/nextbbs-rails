
module Nextbbs

class Form::Comment < Comment
  REGISTRABLE_ATTRIBUTES = %i(name body)
  attr_accessor :name, :body

  # def initialize(attributes = {})
  #   super attributes
  # end
end

end