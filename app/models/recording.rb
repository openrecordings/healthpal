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

  before_create :set_duration

  TMP_PATH = "#{Rails.root}/recordings_tmp"
  DURATION_RGX = /\d\d:\d\d:\d\d.\d\d/

  def ogg_file
    "#{TMP_PATH}/#{self.id}.ogg"
  end

  def wav_file
    "#{TMP_PATH}/#{self.id}.wav"
  end

  def tmp_file_size
    File.exists?(path) ? File.size(path) : nil
  end

  private

  def set_duration
    File.open(ogg_file, 'wb') { |file| file.write(self.audio) } unless File.exists? ogg_file
    `ffmpeg -i #{ogg_file} -ar 100 -y #{wav_file}`
    duration_row = `ffmpeg -i #{wav_file} 2>&1 | grep Duration`
    wav_duration = duration_row.match(DURATION_RGX).to_s
    minutes = (wav_duration[6] + wav_duration[7]).to_i
    seconds = (wav_duration[9] + wav_duration[1]).to_i
    self.duration = minutes * 60 + seconds
  end

end
