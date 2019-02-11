class UserField < ApplicationRecord

  belongs_to :user

  enum type: [:provider, :note]

  self.inheritance_column = nil

end
