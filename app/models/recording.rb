class Recording < ApplicationRecord
  belongs_to :user

  attr_encrypted :audio, key: Rails.application.config.audio_encryption_key, encode: false, encode_iv: false 
end
