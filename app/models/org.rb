class Org < ApplicationRecord
  has_many :users
  has_many :recordings, through: :user

end
