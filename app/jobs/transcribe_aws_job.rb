class TranscribeAwsJob < ApplicationJob
  queue_as :default

  def perform(recording)
    @recording = recording
    @credentials = Rails.application.credentials
    transcode
    transcribe
    create_utterances
    set_is_processed
    send_is_processed_email
    # create_recording_processed_message
    # create_reminder_message
    # create_next_appt_message
  end

  private

  def sent_is_processed_email
    recipient = 'will.haslett@gmail.com'
		htmlbody =
			'<h1>Amazon SES test (AWS SDK for Ruby)</h1>'\
			'<p>This email was sent with <a href="https://aws.amazon.com/ses/">'\
			'Amazon SES</a> using the <a href="https://aws.amazon.com/sdk-for-ruby/">'\
			'AWS SDK for Ruby</a>.'
    ses = Aws::SES::Client.new(region: 'us-east-1')
    begin
      resp = ses.send_email({
        destination: {
          to_addresses: [
            recipient,
          ],
        },
        message: {
          body: {
            html: {
              charset: 'UTF-8',
              data: htmlbody,
            },
            text: {
              charset: 'UTF-8',
              data: 'foo',
            },
          },
          subject: {
            charset: 'UTF-8',
            data: 'Yes!',
          },
        },
      source: sender,
      })
      puts "Email sent!"
    rescue Aws::SES::Errors::ServiceError => error
      puts "Email not sent. Error message: #{error}"
    end
  end

  def transcode
    @recording.media_file.open do |file|
      `ffmpeg -i #{file.path} -ac 1 -ar 16000 #{file.path}.mp3`
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

  # def create_recording_processed_message
  #   Message.create(
  #     recording: @recording,
  #     message_template: MessageTemplate.find_by(trigger: :after_processing),
  #     deliver_at: Time.now,
  #     deliver: true,
  #     to_email: true
  #   )
  # end

  # def create_reminder_message
  #   Message.create(
  #     recording: @recording,
  #     message_template: MessageTemplate.find_by(trigger: :time_after_recording),
  #     deliver_at: Time.now + 2.minutes,
  #     deliver: true,
  #     to_email: true
  #   )
  # end

  # This doesn't belong here. Trigger this message when next_appt is added
  # def create_next_appt_message
  #   Message.create(
  #     recording: @recording,
  #     message_template: MessageTemplate.find_by(trigger: :pre_followup),
  #     deliver_at: @recording.next_appt_at - 2.seconds,
  #     deliver: true,
  #     to_email: true
  #   ) if @recording.next_appt
  # end

end
