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
    # NOTE: Currently only supports Google STT
    transcript = Transcript.new(recording: self, source: :google)
    stt_cmd = TTY::Command.new
    stt_file = 'gs://health-pal-bucket/ge10.flac' 
    stt_string = "gcloud ml speech recognize-long-running #{stt_file} --language-code='en-US' --async --include-word-time-offsets --encoding='flac'"
    # Start the STT job
    stt_cmd_stdout, stt_cmd_stderr = stt_cmd.run(stt_string)
    Rails.logger.debug(stt_cmd_stderr) and return if stt_cmd_stderr
    stt_job_name = JSON.parse(stt_cmd_stdout).name
    poll_cmd = TTY::Command.new
    poll_String = "gcloud ml speech operations wait #{stt_job_name}"
    # Poll the STT job and get transcript JSON (stdout)
    poll_cmd_stdout, pol_cmd_stderr = stt_cmd.run(poll_string)
    Rails.logger.debug(poll_cmd_stderr) and return if poll_cmd_stderr
    transcript.json = JSON.parse(poll_cmd_stdout)
    transcript.save
    Rails.logger.debug('TRANSCRIPT SAVED') and return if stt_cmd_stderr
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
