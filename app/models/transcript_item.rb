# Holds the raw AWS Transcripe Medical transcript text for the parent recording
class TranscriptItem < ApplicationRecord
  belongs_to :recording

  validates_presence_of :recording

  default_scope { order(:id) }

end
