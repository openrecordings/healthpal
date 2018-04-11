class Recording < ApplicationRecord

  belongs_to :user
  has_one :transcript, dependent: :destroy
  has_many :tags, through: :transcript

  #
  # Fields not otherwise mentioned:
  #   patient_identifier (string) - arbitrary, optional patient identifier. Can be used if the User
  #                                 is recording audio for several other people.
  #   provider (string)           - arbitrary, optional provider name.

  attr_encrypted :audio, key: Rails.application.config.audio_encryption_key, encode: false, encode_iv: false

  after_save :set_duration

  TMP_PATH = "#{Rails.root}/recordings_tmp"

  def path
    "#{TMP_PATH}/#{self.id}.ogg"
  end

  # Creates tmp file for recording and returns file size in bytes
  def make_tmp_file!
    File.open(path, 'wb') { |file| file.write(self.audio) } unless File.exists? path
  end

  def tmp_file_size
    File.exists?(path) ? File.size(path) : nil
  end

  private

  def set_duration
    make_tmp_file!
    self.update! duration: (tmp_file_size / 10332) unless duration
  end

end
