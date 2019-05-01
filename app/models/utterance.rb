# Holds one utterance (block of uninterrupted speech) from a transcript
#  index:     position of utterance in transcript (e.g. 2 is the second utterance)
#  begins_at: the starting poing of the utterance in the recording, in seconds 
#  text:      the ascii content of the utterance
class Utterance < ApplicationRecord
  belongs_to :recording
  has_many :tags, dependent: :destroy
  has_many :links

  validates_presence_of :recording

  attr_accessor :acusis_file
  attr_accessor :tmp_tag_types

  # TODO: Encrypt the text attribute
  
  def self.process_acusis
  end
  
  def  tag_types
    tag_types = []
    self.tags.each do |tag|
      tag_types << tag.tag_type
    end
    tag_types
  end
  
end
