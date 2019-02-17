class UserField < ApplicationRecord

  belongs_to :recording

  enum type: [:provider, :note]

  self.inheritance_column = nil

  validates_presence_of :user, :type
  validates_uniqueness_of :user, scope: :type

end
