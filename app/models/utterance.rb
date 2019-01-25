class Utterance < ApplicationRecord
  include ActiveModel::Model
  belongs_to :transcript
  has_many :tags, dependent: :destroy
  
end
