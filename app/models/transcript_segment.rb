class TranscriptSegment < ApplicationRecord
  belongs_to :recording

  validates_presence_of :recording

  default_scope { order(:id) }
end