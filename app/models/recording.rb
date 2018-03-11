class Recording < ApplicationRecord

  belongs_to :user
  has_one :transcript, dependent: :destroy
  has_many :tags, through: :transcript

  attr_encrypted :audio, key: Rails.application.config.audio_encryption_key, encode: false, encode_iv: false

  after_validation :set_duration
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
    self.duration = (tmp_file_size / 10332)
  end

end
