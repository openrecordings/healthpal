class Tag < ApplicationRecord
  belongs_to :utterance
  belongs_to :tag_type

  validates_presence_of :utterance, :tag_type
  validates_uniqueness_of :tag_type, scope: :utterance
end
