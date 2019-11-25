module Nextbbs
  class Comment < ApplicationRecord
    belongs_to :topic
  end
end
