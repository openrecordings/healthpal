class TranscribeAwsJob < ApplicationJob
  queue_as :default

  def perform(recording)
    @recording = recording
    @credentials = Rails.application.credentials
    transcode
    set_is_processed
    reminder_1
    reminder_2
    reminder_3
  end

  private

  def reminder_1
    Message.create(
      recording: @recording,
      mailer_method: 'reminder_1', 
      deliver_at: (DateTime.now.in_time_zone + 1.day).change({hour: 11, min: 0, sec: 0}),
      deliver: true,
      to_email: true,
      to_sms: true,
      sms_text_function: 'reminder_1_text'
    )
  end

  def reminder_2
    Message.create(
      recording: @recording,
      mailer_method: 'reminder_2', 
      deliver_at: (DateTime.now.in_time_zone + 7.days).change({hour: 11, min: 0, sec: 0}),
      deliver: true,
      to_email: true,
      to_sms: true,
      sms_text_function: 'reminder_2_text'
    )
  end

  def reminder_3
    Message.create(
      recording: @recording,
      mailer_method: 'reminder_3', 
      deliver_at: (DateTime.now.in_time_zone + 1000.days).change({hour: 11, min: 0, sec: 0}),
      deliver: true,
      to_email: true,
      to_sms: true,
      sms_text_function: 'reminder_3_text'
    )
  end

  def transcode
    @recording.media_file.open do |file|
      `ffmpeg -i #{file.path} -af "loudnorm" -ac 1 -ar 48000 #{file.path}.mp3`
      @recording.media_file.attach(io: File.open("#{file.path}.mp3"), filename: "#{@recording.sha1}.mp3")
    end
  end

  def transcribe
    bucket_name = @credentials[Rails.env.to_sym][:transcript_bucket_name]
    aws_client = Aws::TranscribeService::Client.new
    media_file_uri = "https://s3-#{@credentials.aws[:region]}.amazonaws.com/#{@credentials[Rails.env.to_sym][:media_bucket_name]}/#{@recording.media_file.key}"
    job_name = "orals_transcibe_job_#{Time.now.to_s.gsub(' ','_').gsub(':', '_').gsub('+', '')}"
    aws_client.start_transcription_job(
      transcription_job_name: job_name,
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
      job_status = aws_client.get_transcription_job({transcription_job_name: job_name})
                     .transcription_job
                     .transcription_job_status
      transcription_complete = %w[FAILED COMPLETED].include?(job_status)
      sleep(1)
    end
    # TODO: Handle failure
    @recording.update aws_transcription_uri: aws_client.get_transcription_job({transcription_job_name: job_name})
                                    .transcription_job.transcript.transcript_file_uri
    bucket_name = @credentials[Rails.env.to_sym][:transcript_bucket_name]
    aws_s3_client = Aws::S3::Client.new(region: @credentials.aws[:region])
    @recording.update json: aws_s3_client.get_object(bucket: bucket_name, key: "#{job_name}.json").body.read
  end

  def create_utterances
    return unless @recording.aws_transcription_uri && @recording.json
    @recording.utterances.each{|u| u.destroy}
    transcript_hash = JSON.parse(@recording.json)
    items = transcript_hash['results']['items']
    if items.any?
      segments = transcript_hash['results']['speaker_labels']['segments']
      segments.each_with_index do |s, i|
        segment_items = items.select{|i| i['start_time'] && i['end_time'] && i['start_time'] >= s['start_time'] && i['start_time'] < s['end_time']}
        if segment_items.any?
          segment_text = ''
          segment_items.each do |item|
            segment_text.chop! if segment_text.present? && segment_text[-1] && segment_text[-1] == ' ' && item['type'] == 'punctuation'
            segment_text << item['alternatives'][0]['content'] + ' '
          end
          utterance = Utterance.create(
            recording: @recording,
            index: Utterance.where(recording_id: @recording.id).count,
            begins_at: s['start_time'].to_i,
            ends_at: s['end_time'].to_i,
            text: segment_text
          )
          # TODO Remove. This is only for demo purposes
          Tag.create(
            utterance: utterance,
            tag_type_id: rand(1..4)
          )
        end
      end
    end
  end

  def set_is_processed
    @recording.update is_processed: true
  end

end
