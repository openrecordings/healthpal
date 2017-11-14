class Tag < ApplicationRecord
  belongs_to :utterance
  belongs_to :tag_type
end
