class Link < ApplicationRecord
  belongs_to :utterance

  validates_presence_of :utterance

end
