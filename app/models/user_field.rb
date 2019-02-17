class UserField < ApplicationRecord

  belongs_to :recording

  enum type: [:provider, :note]

  self.inheritance_column = nil

  validates_presence_of :recording, :type
  validates_uniqueness_of :recording, scope: :type

end
