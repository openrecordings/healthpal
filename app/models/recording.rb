require "google/cloud/storage"
require "google/cloud/speech"

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
  # TODO: Async, Error-handling, Upload tempfile and deprecate local file
  def upload
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts 'upload'
    return nil unless self.persisted?
    storage_job = Google::Cloud::Storage.new(project: Rails.configuration.gcp_project_name)
    bucket = storage_job.bucket(Rails.configuration.gcp_bucket_name)
    bucket.create_file(self.local_file_name_with_path.to_s, self.file_name)
    self.update(uri: storage_job.signed_url(bucket_name, local_file_name_with_path))
    puts 'AUDIO FILE UPLOADED'
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  end

  # Get GCP speech transcription JSON and store in self
  # TODO: Async, Error-handling
  def transcribe
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    puts 'transcribe'
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
     }
    audio  = {uri: self.uri}
    operation = stt_job.long_running_recognize(stt_config, audio)
    puts "Operation started"
    operation.wait_until_done!
    raise operation.results.message if operation.error?

    # Add result JSON to transcript
    transcript.update(json: operation.response.results)
    puts 'AUDIO FILE TRANSCRIBED'
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  end

  # Returns self's audio file path/name as a Pathname object.
  # Will return nil if called when self.file_name doesn't yet exist
  def local_file_name_with_path
    return nil unless self.file_name
    Rails.configuration.local_audio_file_path.join(self.file_name)
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
