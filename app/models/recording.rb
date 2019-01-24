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
		puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
		speech = Google::Cloud::Speech.new
		config     = { encoding:          :FLAC,
									 sample_rate_hertz: 16000,
									 language_code:     "en-US"   }
		audio  = { uri: 'gs://health-pal-bucket/ge10.flac' }
		operation = speech.long_running_recognize config, audio
		puts "Operation started"
		operation.wait_until_done!
		raise operation.results.message if operation.error?
		results = operation.response.results
		alternatives = results.first.alternatives
		alternatives.each do |alternative|
      puts "Transcription: #{alternative.transcript}"
    end
		puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
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

  def gcp_logger
    @@gcp_logger ||= Logger.new("#{Rails.root}/log/gcp.log")
  end

end
