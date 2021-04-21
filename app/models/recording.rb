class Recording < ApplicationRecord
  belongs_to :user
  has_many :transcript_items, dependent: :destroy
  has_many :transcript_segments, dependent: :destroy
  has_many :annotations, through: :transcript_segments
  has_many :utterances, -> {order 'index asc'}, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :annotations, through: :transcript_segments
  has_one_attached :media_file
  visitable :ahoy_visit

  validates_presence_of :title

  scope :processed, -> {where(is_processed: true)}
  scope :audited, -> {where(user_can_access: true)}

  MEDLINE_SEARCH_TEMPLATE = 'https://wsearch.nlm.nih.gov/ws/query?db=healthTopics&term=!!!&rettype=brief'

  def notes
    recording_notes
  end

  def process!
    ProcessRecordingJob.perform_later(self)
  end

  def create_ready_email
    Message.create(
      recording: self,
      deliver_at: DateTime.now() + 1.year,
      to_email: self.user&.email,
      mailer_method: 'r01_recording_ready',
    )
  end

  def send_ready_email
    message = messages.find{|m| m.mailer_method == 'r01_recording_ready'}
    return unless message
    MessageJob.perform_later(message)
  end

  def transcode
    return unless media_file
    media_file.open do |file|
      `ffmpeg -i #{file.path} -ac 1 -ar 48000 #{file.path}.mp3`
      media_file.attach(io: File.open("#{file.path}.mp3"), filename: "#{sha1}.mp3")
    end
  end

  def transcribe
    credentials = Rails.application.credentials
    bucket_name = credentials[Rails.env.to_sym][:transcript_bucket_name]
    transcribe_client = Aws::TranscribeService::Client.new
    s3_client = Aws::S3::Client.new(region: credentials.aws[:region])
    media_file_uri = "https://s3-#{credentials.aws[:region]}.amazonaws.com/#{credentials[Rails.env.to_sym][:media_bucket_name]}/#{media_file.key}"
    job_name = "orals_medical_transcibe_job_#{Time.now.to_s.gsub(' ', '_').gsub(':', '_').gsub('+', '')}"
    transcribe_client.start_medical_transcription_job(
      medical_transcription_job_name: job_name,
      settings: {
        show_speaker_labels: true,
        max_speaker_labels: 2
      },
      language_code: 'en-US',
      media_sample_rate_hertz: 48_000,
      media_format: 'mp3',
      media: { media_file_uri: media_file_uri },
      output_bucket_name: bucket_name,
      specialty: 'PRIMARYCARE',
      type: 'CONVERSATION'
    )
    transcription_complete = false
    until transcription_complete
      job_status = transcribe_client.get_medical_transcription_job({ medical_transcription_job_name: job_name })
                             .medical_transcription_job
                             .transcription_job_status
      transcription_complete = %w[FAILED COMPLETED].include?(job_status)
      sleep(1)
    end
    # TODO: Handle failure
    update aws_transcription_uri: transcribe_client.get_medical_transcription_job({ medical_transcription_job_name: job_name })
                                            .medical_transcription_job.transcript.transcript_file_uri
    response_json =  s3_client.get_object(bucket: bucket_name, key: "medical/#{job_name}.json").body.read
    self.update transcript_json: response_json
    self.update speakers: JSON.parse(transcript_json)['results']['speaker_labels']['speakers']
    create_transcript_items
  end

  def create_transcript_items
    byte_limit = 4000 #20000
    JSON.parse(transcript_json)['results']['speaker_labels']['segments']&.each do |transcript_segment|
      TranscriptSegment.create(
        recording: self,
        start_time: transcript_segment['start_time'],
        end_time: transcript_segment['end_time'],
        speaker_label: transcript_segment['speaker_label'],
      )
    end

    transcript = ''
    transcript_count = 0
    JSON.parse(transcript_json)['results']['items']&.each do |transcript_item|
      content = transcript_item['alternatives'][0]['content'] + ' '
      current_transcript_length = transcript.length
      transcript << content

      if transcript.bytesize / byte_limit > 0
        transcript_count += 1
        transcript = content
        begin_offset = 0
        end_offset = transcript.length
      else
        begin_offset = current_transcript_length
        end_offset = begin_offset + content.length
      end

      TranscriptItem.create(
        recording: self,
        count: transcript_count,
        start_time: transcript_item['start_time'],
        end_time: transcript_item['end_time'],
        content: content,
        kind: transcript_item['type'],
        begin_offset: begin_offset,
        end_offset: end_offset
      )
    end
  end

  def print_trans_item(t)
    puts "time: #{t.start_time}, #{t.end_time}, offset: #{t.begin_offset}, #{t.end_offset}, content #{t.content}"
  end

  def transcript_string
    transcript_items.map{|transcript_item| transcript_item.content}.reduce(:+)
  end

  def sub_transcript_string(count)
    transcript_items.select{|t| t.count == count}.map{|transcript_item| transcript_item.content}.reduce(:+)
  end

  def annotate
    count = 0
    current_transcript_items = self.transcript_items.select{|t| t.count == count}
    while current_transcript_items.any?
      transcript = sub_transcript_string(count)

      comprehend_client = Aws::ComprehendMedical::Client.new(region: Rails.application.credentials.aws[:region])
      # TODO: Error handling
      aws_annotations = comprehend_client.detect_entities_v2('text': transcript).entities
      self.update annotation_json: aws_annotations.to_json
      aws_annotations.each do |annotation|
        create_annotation(annotation, count)
        curr_annotation = annotations.all.find{|a| a.aws_id == annotation.id}
        if curr_annotation
          unless annotation.attributes.blank?
            annotation.attributes.each do |attribute|
              create_annotation(attribute, count, false)
              sub_annotation = annotations.all.find{|a| a.aws_id == attribute.id}
              if sub_annotation
                AnnotationRelation.create(
                  annotation: curr_annotation,
                  score: attribute.relationship_score,
                  kind: attribute.relationship_type,
                  related_annotation_id: sub_annotation.id
                )
              end
            end
          end
        end
      end

      count += 1
      current_transcript_items = self.transcript_items.select{|t| t.count == count}
    end
  end

  def create_annotation(annotation, count, is_top_level=true)
    puts "ANNOTATION: #{annotation}"
    print_trans_item(transcript_items.select{|t| t.count == count}.find{|i| i.begin_offset >= annotation.begin_offset})
    print_trans_item(transcript_items.select{|t| t.count == count}.find{|i| i.end_offset >= annotation.end_offset})
    puts "\n"

    start_time = transcript_items.select{|t| t.count == count}.find{|i| i.begin_offset >= annotation.begin_offset}.start_time
    end_time = transcript_items.select{|t| t.count == count}.find{|i| i.end_offset >= annotation.end_offset}.end_time
    transcript_segment = transcript_segments.find{|segment| segment.end_time >= end_time}
    curr_annotation = annotations.all.find{|a| a.aws_id == annotation.id}

    if curr_annotation
      curr_annotation.update_attribute(:top, is_top_level) if !curr_annotation.top && is_top_level
    elsif !['PROTECTED_HEALTH_INFORMATION', 'ANATOMY'].include?(annotation.category)
      begin
        api_call_url = MEDLINE_SEARCH_TEMPLATE.gsub('!!!', annotation.text.downcase)
        medline_hash = HTTParty.get(api_call_url).to_h
        document_hash = medline_hash['nlmSearchResult']['list']['document'][0]
        summary_string = document_hash['content'].find {|h| h['name'] == 'FullSummary'}['__content__']
        url_string = document_hash['url']
        medline_summary = summary_string
        medline_url = url_string
      rescue => exception
        puts exception.to_s
        medline_summary = nil
        medline_url = nil
      end
      Annotation.create(
        transcript_segment: transcript_segment,
        category: annotation.category,
        begin_offset: annotation.begin_offset,
        end_offset: annotation.end_offset,
        text: annotation.text,
        kind: annotation.type,
        score: annotation.score,
        aws_id: annotation.id,
        start_time: start_time,
        end_time: end_time,
        top: is_top_level,
        medline_summary: medline_summary,
        medline_url: medline_url,
      )
      curr_annotation = annotations.all.find{|a| a.aws_id == annotation.id}
    end

    if curr_annotation
      unless annotation.traits.blank?
        annotation.traits.each do |t|
          if t.name == "SYMPTOM"
            curr_annotation.update_attribute(:category, t.name)
            curr_annotation.update_attribute(:score, t.score)
          else
            AnnotationTrait.create(
              annotation: curr_annotation,
              score: t.score,
              name: t.name
            )
          end
        end
      end
    end

  end

  def destroy_annotations
    transcript_segments.each do |t|
      t.annotations.destroy_all
    end
  end

  private

  def sanitize(string)
    ActionView::Base.full_sanitizer.sanitize(string)
  end
end
