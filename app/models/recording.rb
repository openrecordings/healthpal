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
  after_create :transcribe

  private

  def encrypt
    # TODO: Use gpg and the Open3 Ruby module
    # Put the local GPG user ID in application.yml?
  end

  def set_duration
  end

  def create_blank_fields
    # Blank (existing) fields are required for best_in_place
    self.note = ''
    self.provider = ''
  end

  def transcribe
    # TODO: This needs to be split into a model method and a controller method, for error-handling
    #       Run as a private controller method after recording creation
    # Initialize Transcript record
    transcript = Transcript.new(
      recording: self,
      source: :google
    )
    # Send gcloud STT command
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    stt_cmd = 'gcloud'
    stt_options = "ml speech recognize-long-running --language-code='en-US' --async --include-word-time-offsets --encoding='flac'"
    stt_file = 'gs://health-pal-bucket/ge10.flac' 
    stt_stdout, stt_status = Open3.capture2(stt_cmd, stt_file, stt_options)
    if stt_status.success?
      # Poll job and get JSON results
      job_name = JSON.parse(stt_stdout).name

      puts "job_name: #{job_name}"

      poll_cmd = 'gcloud ml speech operations wait'
      poll_stdout, poll_status = Open3.capture2(poll_cmd, job_name)
      if poll_status.success?
        transcript.json = JSON.parse(poll_stdout)
        transcript.save!
      else
        transcript.errors.add(:base, 'An error occured during transcription')
      end
    else
      transcript.errors.add(:base, 'An error occured initiating transcription')
      return
    end
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  end
    

end
