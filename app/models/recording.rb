require "google/cloud/storage"
require "google/cloud/speech"

class Recording < ApplicationRecord

  belongs_to :user
  has_many :utterances
  has_many :user_fields

  # Add all supported transcription services here
  # TODO: Add old Acusis code back in after getting gcloud going?
  enum source: [:google]

  #
  # Fields not otherwise mentioned:
  #   patient_identifier (string) - arbitrary, optional patient identifier. Can be used if the User
  #                                 is recording audio for several other people.
  #   provider (string)           - arbitrary, optional provider name.

  # TODO: Encrypt other stuff?
  # attr_encrypted :audio, key: Rails.application.config.audio_encryption_key, encode: false, encode_iv: false

  before_create :encrypt
  before_create :set_duration

  def upload
  end

  # Upload audio file to GCP
  # Will return nil unless self is persisted
  # TODO:
	#  Async
  #  Error-handling
  # def upload
    # return nil unless self.persisted?
    # storage_job = Google::Cloud::Storage.new(project: Rails.configuration.gcp_project_name)
    # bucket_name = Rails.configuration.gcp_bucket_name
    # bucket = storage_job.bucket(bucket_name)
    # audio_file_path = self.local_file_name_with_path
    # file = bucket.create_file(audio_file_path, self.file_name)
    # self.update(uri: "gs://#{bucket_name}/#{self.file_name}", url:file.public_url)
  #end

  # TODO
  def download
  end

  # Get GCP speech transcription JSON and store in self
  # TODO:
	#  Async
  #  Error-handling
  #  Delete local and GCP file if they already exist (warn user?)
  #  Upload tempfile and deprecate local file
  # def transcribe
		# return nil unless self.persisted? && self.uri
    # # Find or create transcript
    # self.json = [].to_json
    # # Create and submit STT job
    # stt_job = Google::Cloud::Speech.new
    # stt_config = {encoding: :FLAC,
    #   sample_rate_hertz: 16000,
    #   language_code: 'en-US',
    #   enable_word_time_offsets: true,
    #   enable_automatic_punctuation: true,
    #   max_alternatives: 1
    # }
    # audio  = {uri: self.uri}
    # operation = stt_job.long_running_recognize(stt_config, audio)
    # operation.wait_until_done!
    # raise operation.results.message if operation.error?
    # # Add result JSON to transcript
    # self.update(json: operation.response.results)
  # end

  # Returns self's audio file path/name as a String
  # Will return nil if called when self.file_name doesn't yet exist
  def local_file_name_with_path
    return nil unless self.file_name
    Rails.configuration.local_audio_file_path.join(self.file_name).to_s
  end

  # TODO Remove. This is part of the tmp file approach to streaming
  def tmp_file_name
    return nil unless self.file_name
    "tmp_#{self.file_name}"
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

  # TODO Use this
  def gcp_logger
    @@gcp_logger ||= Logger.new("#{Rails.root}/log/gcp.log")
  end

end

