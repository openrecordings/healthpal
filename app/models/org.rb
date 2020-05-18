class Org < ApplicationRecord
  has_many :users

  # scope :all_users, -> {User.where(org: self)}

  def all_users
    User.where(org: self)
  end

end
