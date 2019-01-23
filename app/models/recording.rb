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

  attr_encrypted :audio, key: Rails.application.config.audio_encryption_key, encode: false, encode_iv: false

  before_create :set_duration
  before_create :create_note

  private

  def set_duration
  end

  def create_note
    # This silliness is due to the way the best_in_place gem works. It needs a persisted record
    # to work with and we want to use it for "creation" as well as updating, so for now, all
    # recordings start with blank UserNotes
    self.user_note = UserNote.new
    self.provider = ''
  end

end
