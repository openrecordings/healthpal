# Holds one utterance (block of uninterrupted speech) from a transcript
#  index:     position of utterance in transcript (e.g. 2 is the second utterance)
#  begins_at: the starting poing of the utterance in the recording, in seconds 
#  text:      the ascii content of the utterance
class Utterance < ApplicationRecord
  belongs_to :recording
  has_many :tags, dependent: :destroy
  has_many :links

  # TODO: Encrypt the text attribute
  
end
