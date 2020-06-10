class UserField < ApplicationRecord

  belongs_to :recording

  enum kind: [:description, :provider, :note]

  validates_presence_of :recording, :kind
  validates_uniqueness_of :recording, scope: :kind

end
