class UserField < ApplicationRecord

  belongs_to :user

  enum type: [:provider, :recording_note]

  self.inheritance_column = nil

end
