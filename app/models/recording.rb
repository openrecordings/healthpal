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

  # Upload audio file to GCP
  # Will return nil unless self is persisted
  # TODO: Async, Error-handling
  def upload
    return nil unless self.persisted?
    Google::Cloud::Storage.new.storage.bucket.file = local_file_name_with_path
  end

  # Get GCP speech transcription JSON and store in self
  # TODO: Async, Error-handling
  def transcribe
    starttime = Time.now

    # Find or create transcript
    transcript = self.transcript || Transcript.create(recording: self,
                                                      source: :google,
                                                      json: [].to_json )

    # Create and submit STT job
    stt_job = Google::Cloud::Speech.new
    stt_config = {encoding: :FLAC,
      sample_rate_hertz: 16000,
      language_code: 'en-US',
      enable_word_time_offsets: true
      # async: true
     }
    audio  = {uri: 'gs://health-pal-bucket/ge10_short.flac'}
    operation = stt_job.long_running_recognize(stt_config, audio)
    puts "Operation started"
    operation.wait_until_done!
    raise operation.results.message if operation.error?

    # Add result JSON to transcript
    transcript.update(json: operation.response.results)

    puts '--------------------------------------------------------------'
    puts "Transcription time (minutes): #{(Time.now - starttime)/60}"
    puts '--------------------------------------------------------------'
  end

  # Returns self's audio file path/name.
  # NOTE: Will return nil if called when self.file_hash doesn't yet exist
  def local_file_name_with_path
    return nil unless self.file_hash
    Rails.configuration.local_audio_file_path.join(self.file_hash)
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
