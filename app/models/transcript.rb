# Holds the raw transcript for a recording. 
class Transcript < ApplicationRecord
  belongs_to :recording  
  has_many :utterances, -> {order 'index asc'}, dependent: :destroy
  has_many :tags, through: :utterances

  validates_presence_of :recording, :source, :json

  # Add all supported transcription services here
  # TODO: Add old Acusis code back in after getting gcloud going?
  enum source: [:google]

end
