class Recording < ApplicationRecord

  belongs_to :user
  has_one :transcript, dependent: :destroy
  has_one :user_note
  has_many :tags, through: :transcript

  #
  # Fields not otherwise mentioned:
  #   patient_identifier (string) - arbitrary, optional patient identifier. Can be used if the User
  #                                 is recording audio for several other people.
  #   provider (string)           - arbitrary, optional provider name.

  # TODO: Encrypt other stuff?
  # attr_encrypted :audio, key: Rails.application.config.audio_encryption_key, encode: false, encode_iv: false

  before_create :encrypt
  before_create :set_duration

  def transcribe
  end

  private

  def encrypt
    # TODO: Use gpg and the Open3 Ruby module
    # Put the local GPG user ID in application.yml?
  end

  def set_duration
    # TODO
  end

  def create_blank_fields
    # Blank (existing) fields are required for best_in_place
    self.note = ''
    self.provider = ''
  end

end
