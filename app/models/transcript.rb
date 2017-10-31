# Holds the raw transcript for a recording. 
class Transcript < ApplicationRecord
  belongs_to :recording  
  has_many :utterances

  validates_presence_of :recording, :format, :raw
  
  attr_accessor :file

  # Seems somewhat likely that we will have to support more than transcription format
  enum source: [:acusis]

  def raw_from_file
    return nil unless (system 'which unrtf') && @file && source && @file.is_a?(ActionDispatch::Http::UploadedFile)
    if acusis?
      self.raw = `unrtf #{@file.tempfile.path} --text`
    else 
      nil
    end
  end
end
