class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :nextbbs_boards, class_name: "Nextbbs::Board", foreign_key: "owner_id"
  has_many :nextbbs_comments, class_name: "Nextbbs::Comment", foreign_key: "owner_id"
end
