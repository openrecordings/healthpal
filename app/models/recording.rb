class Recording < ApplicationRecord
  belongs_to :user
  has_one :transcript
  has_many :tags, through: :transcript

  attr_encrypted :audio, key: Rails.application.config.audio_encryption_key, encode: false, encode_iv: false
end
