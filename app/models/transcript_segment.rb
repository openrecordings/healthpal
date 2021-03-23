class TranscriptSegment < ApplicationRecord
  belongs_to :recording
  has_many :annotations, dependent: :destroy

  validates_presence_of :recording

  default_scope { order(:id) }
end
