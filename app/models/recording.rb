require "google/cloud/storage"
require "google/cloud/speech"

class Recording < ApplicationRecord

  belongs_to :user
  has_many :utterances, -> {order 'index asc'}, dependent: :destroy
  has_many :user_fields

  # Add all supported transcription services here
  # TODO: Add old Acusis code back in after getting gcloud going?
  enum source: [:google, :aws]

  # TODO: Validation

  def upload
    self.send("upload_#{Rails.configuration.cloud_provider}")
  end

  def download
    self.send("download_#{Rails.configuration.cloud_provider}")
  end

  def transcribe
    self.send("transcribe_#{Rails.configuration.cloud_provider}")
  end

  # AWS
  #################################################################################################
  def upload_aws
    bucket_name = Rails.configuration.aws_media_bucket_name
    s3 = Aws::S3::Resource.new(region: Rails.configuration.aws_region)
    s3_object = s3.bucket(bucket_name).object(file_name)
    s3_object.upload_file(media_path, {acl: 'private'})
    update(
      aws_bucket_name: bucket_name,
      aws_public_url: s3_object.public_url,
      aws_media_key: s3_object.key
    )
  end

  def transcribe_aws
    bucket_name = Rails.configuration.aws_transcript_bucket_name
    aws_client = Aws::TranscribeService::Client.new
    media_file_uri = "https://s3-#{Rails.configuration.aws_region}.amazonaws.com/#{Rails.configuration.aws_media_bucket_name}/#{aws_media_key}"
    #TODO Make sure the job launched properly
    aws_client.start_transcription_job(
      transcription_job_name: file_name,
      settings: {
        show_speaker_labels: true,
        max_speaker_labels: 2
      },
      language_code: 'en-US',
      media_sample_rate_hertz: 16000,
      media_format: 'mp3',
      media: {media_file_uri: media_file_uri},
      output_bucket_name: bucket_name
    )
    transcription_complete = false
    until transcription_complete
      job_status = aws_client.get_transcription_job({transcription_job_name: file_name})
                     .transcription_job
                     .transcription_job_status
      transcription_complete = %w[FAILED COMPLETED].include?(job_status)
      sleep(1)
    end
    # TODO: Handle failure
    update aws_transcription_uri: aws_client.get_transcription_job({transcription_job_name: file_name})
                                    .transcription_job.transcript.transcript_file_uri
    bucket_name = Rails.configuration.aws_transcript_bucket_name
    aws_s3_client = Aws::S3::Client.new(region: Rails.configuration.aws_region)
    update json: aws_s3_client.get_object(bucket: bucket_name, key: "#{file_name}.json").body.read
  end

  # TODO: Finish
  def create_utterances_aws
    return unless aws_transcription_uri && json
    transcript_hash = JSON.parse(json)
    items = transcript_hash['results']['items']
    ap puts items
    segments = transcript_hash['results']['speaker_labels']['segments']
    segments.each do |s|
      start_index = items.index{|i| i['start_time'] == s['start_time']}
      end_index = items.index{|i| i['end_time'] == s['end_time']}
      segment_items = items[start_index..end_index]
      puts ap segment_items
      break
    end
    return nil
  end

  # GC
  #################################################################################################
  # Upload audio file to GCP
  # Will return nil unless self is persisted
  # TODO:
  #  Async
  #  Error-handling
  def upload_gcp
    return nil unless self.persisted?
    storage_job = Google::Cloud::Storage.new(project: Rails.configuration.gcp_project_name)
    bucket_name = Rails.configuration.gcp_bucket_name
    bucket = storage_job.bucket(bucket_name)
    audio_file_path = self.media_path
    file = bucket.create_file(audio_file_path, self.file_name)
    self.update(gcp_uri: "gs://#{bucket_name}/#{self.file_name}", gcp_public_url: file.public_url)
  end

  # Get GCP speech transcription JSON and store in self
  # TODO:
  #  Async
  #  Error-handling
  #  Delete local and GCP file if they already exist (warn user?)
  #  Upload tempfile and deprecate local file
  def transcribe_gcp
    return nil unless self.persisted? && self.gcp_uri
    # Find or create transcript
    self.json = [].to_json
    # Create and submit STT job
    stt_job = Google::Cloud::Speech.new
    stt_config = {encoding: :FLAC,
                  sample_rate_hertz: 16000,
                  language_code: 'en-US',
                  enable_word_time_offsets: true,
                  enable_automatic_punctuation: true,
                  max_alternatives: 1
    }
    audio = {uri: self.gcp_uri}
    operation = stt_job.long_running_recognize(stt_config, audio)
    operation.wait_until_done!
    raise operation.results.message if operation.error?
    # Add result JSON to transcript
    self.update(json: operation.response.results)
  end

  #################################################################################################

  def media_path
    return nil unless self.file_name
    Rails.root.join('protected_media').join(self.file_name).to_s
  end

  def ogg_path
    media_path.gsub('.mp3', '.ogg')
  end

  # Transcript upload (Acusis)
  #################################################################################################
  attr_accessor :transcript_txt_file

  ACUSIS_RAW_TIMESTAMP = /\A\d\d:\d\d/
  ACUSIS_PERSON_ID = /\APERSON [A-Z]:/

  def build_utterances
    # Destroy and existing utterances for self (user was warned)
    self.utterances.each {|u| u.destroy}
    # TODO: This breaks if the recording is longer than 99 minutes!
    utt = nil
    raw = @transcript_txt_file.read
    rows = raw.split "\n"
    i = 0
    rows.each do |row|
      if row.match ACUSIS_RAW_TIMESTAMP
        i += 1
        mm_ss = row.slice!(ACUSIS_RAW_TIMESTAMP)
        text = row.strip.sub(ACUSIS_PERSON_ID, '').strip
        begins_at = mm_ss[0..1].to_i * 60 + mm_ss[-2..-1].to_i
        if (utt)
          # end at the start time of the next utterance, or 1 second later if the start times are the same
          utt.ends_at = begins_at + ((begins_at == utt.begins_at) ? 1 : 0)
          self.utterances << utt
        end
        utt = Utterance.new(
          recording: self,
          index: i,
          begins_at: begins_at,
          text: text,
          ends_at: 0
        )
      end
    end
    if (utt)
      utterances << utt
    end
  end

  private

  def encrypt
    # TODO: Use gpg and the Open3 Ruby module
    # Put the local GPG user ID in application.yml?
  end

  def set_duration
    # TODO
  end

  # TODO: Still needed? (Not using a gem for in-place editing anymore)
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

