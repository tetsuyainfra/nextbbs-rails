# usage:
# class User < ApplicationRecord
#   include Nextbbs::OwnerExtender
# end
module Nextbbs
  module OwnerExtender
    extend ActiveSupport::Concern

    included do
      has_many :nextbbs_boards,
               class_name: "Nextbbs::Board", foreign_key: "owner_id"
      has_many :nextbbs_topics,
               class_name: "Nextbbs::Topic", foreign_key: "owner_id"
      has_many :nextbbs_comments,
               class_name: "Nextbbs::Comment", foreign_key: "owner_id"
    end
  end
end
