# Holds one utterance (block of uninterrupted speech) from a transcript
#  index:     position of utterance in transcript (e.g. 2 is the second utterance)
#  begins_at: the starting poing of the utterance in the recording, in seconds 
#  text:      the ascii content of the utterance
class Utterance < ApplicationRecord
  belongs_to :transcript
  has_many :tags, autosave: true

  # TODO
  # has_and_belongs_to_many :tags
  
  # TODO: Encrypt the text attribute
  
end
