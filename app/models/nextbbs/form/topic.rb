
module Nextbbs

class Form::Topic << Topic
  REGISTRABLE_ATTRIBUTES = %i(title)
  attr_accessor :title
end

end