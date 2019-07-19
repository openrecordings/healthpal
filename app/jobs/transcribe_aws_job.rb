class TranscribeAwsJob < ApplicationJob
  queue_as :default

  def perform(recording, aws_credentials)
    @recording = recording
    @aws_credentials = aws_credentials
    transcode
    upload
    transcribe
    create_utterances
    email_user
  end

  private

  def transcode
    `ffmpeg -i #{@recording.ogg_path} -ac 1 -ar 16000 #{@recording.media_path}`
  end

  def upload
    bucket_name = @aws_credentials[:media_bucket_name]
    s3 = Aws::S3::Resource.new(region: @aws_credentials[:region])
    s3_object = s3.bucket(bucket_name).object(@recording.file_name)
    s3_object.upload_file(@recording.media_path, {acl: 'private'})
    @recording.update(
      aws_bucket_name: bucket_name,
      aws_public_url: s3_object.public_url,
      aws_media_key: s3_object.key
    )
  end

  def transcribe
    return unless @recording.aws_media_key
    bucket_name = @aws_credentials[:transcript_bucket_name]
    aws_client = Aws::TranscribeService::Client.new
    media_file_uri = "https://s3-#{@aws_credentials[:region]}.amazonaws.com/#{@aws_credentials[:media_bucket_name]}/#{@recording.aws_media_key}"
    #TODO Make sure the job launched properly
    aws_client.start_transcription_job(
      transcription_job_name: @recording.file_name,
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
      job_status = aws_client.get_transcription_job({transcription_job_name: @recording.file_name})
                     .transcription_job
                     .transcription_job_status
      transcription_complete = %w[FAILED COMPLETED].include?(job_status)
      sleep(1)
    end
    # TODO: Handle failure
    @recording.update aws_transcription_uri: aws_client.get_transcription_job({transcription_job_name: @recording.file_name})
                                    .transcription_job.transcript.transcript_file_uri
    bucket_name = @aws_credentials[:transcript_bucket_name]
    aws_s3_client = Aws::S3::Client.new(region: @aws_credentials[:region])
    @recording.update json: aws_s3_client.get_object(bucket: bucket_name, key: "#{@recording.file_name}.json").body.read
  end

  def create_utterances
    return unless @recording.aws_transcription_uri && @recording.json
    transcript_hash = JSON.parse(@recording.json)
    items = transcript_hash['results']['items']
    segments = transcript_hash['results']['speaker_labels']['segments']
    utterance_index = 1
    utterance_text = ''
    segments.each_with_index do |s, i|
      start_index = items.index {|item| item['start_time'] == s['start_time']}
      end_index = items.index {|item| item['end_time'] == s['end_time']}
      segment_text = ''
      items[start_index..end_index].each do |item|
        segment_text.chop! if segment_text[-1] && segment_text[-1] == ' ' && item['type'] == 'punctuation'
        segment_text << item['alternatives'][0]['content'] + ' '
      end
      utterance_text << segment_text
      if segments[i + 1] && segments[i + 1]['speaker_label'] == s['speaker_label']
        next
      else
        utterance = Utterance.create(
          recording: @recording,
          index: utterance_index,
          begins_at: s['start_time'].to_i,
          ends_at: s['end_time'].to_i,
          text: utterance_text
        )
        utterance_index += 1
        utterance_text = ''

        # TODO Remove. This is only for demo purposes
        Tag.create(
          utterance: utterance,
          tag_type_id: rand(1..3)
        )

      end
    end
  end

  def email_user
    UserMailer.with(recording: @recording).recording_ready.deliver_now
  end

end
