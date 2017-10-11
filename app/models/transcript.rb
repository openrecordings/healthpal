# Holds the raw transcript for a recording. 
class Transcript < ApplicationRecord
  belongs_to :recording  
  has_many :utterances

  # Seems somewhat likely that we will have to support more than transcription format
  enum :format [:acusis]
end
