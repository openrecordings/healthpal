class Org < ApplicationRecord
  has_many :users

  def all_users
    User.where(org: self)
  end

end
