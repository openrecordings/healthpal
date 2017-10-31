# Holds the raw transcript for a recording. 
class Transcript < ApplicationRecord
  belongs_to :recording  
  has_many :utterances

  validates_presence_of :recording, :format, :raw

  # Seems somewhat likely that we will have to support more than transcription format
  enum format: [:acusis]

  def rtf_to_ascii
    return nil unless system 'which unrtf' && raw && format
    if format.acusis?
      system "unrtf #{raw}"
    else 
      nil
    end
  end
end
