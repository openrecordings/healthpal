class Recording < ApplicationRecord
  belongs_to :user
  has_many :annotations, dependent: :destroy
  has_many :transcript_items, dependent: :destroy
  has_many :utterances, -> {order 'index asc'}, dependent: :destroy
  has_many :recording_notes, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one_attached :media_file
  visitable :ahoy_visit

  validates_presence_of :title

  scope :processed, -> {where(is_processed: true)}

  def notes
    recording_notes
  end

  def process!
    ProcessRecordingJob.perform_later(self)
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
    transcript = ''
    JSON.parse(transcript_json)['results']['items']&.each do |transcript_item|
      content = transcript_item['alternatives'][0]['content'] + ' '
      current_transcript_length = transcript.length
      begin_offset = current_transcript_length
      end_offset = begin_offset + content.length
      TranscriptItem.create(
        recording: self,
        start_time: transcript_item['start_time'],
        end_time: transcript_item['end_time'],
        content: content,
        kind: transcript_item['type'],
        begin_offset: begin_offset,
        end_offset: end_offset
      )
      transcript << content
    end
  end

  def transcript_string
    transcript_items.map{|transcript_item| transcript_item.content}.reduce(:+)
  end

  def annotate
    return unless self.transcript_items.any?
    transcript = transcript_string
    comprehend_client = Aws::ComprehendMedical::Client.new(region: Rails.application.credentials.aws[:region])
    # TODO: Error handling
    aws_annotations = comprehend_client.detect_entities_v2('text': self.transcript_string).entities
    self.update annotation_json: aws_annotations.to_json

    aws_annotations.each do |annotation|
      create_annotation(annotation, true)
      curr_annotation = Annotation.find_by(aws_id: annotation.id)

      unless annotation.attributes.blank?
        annotation.attributes.each do |attribute|
          create_annotation(attribute, false)
          sub_annotation = Annotation.find_by(aws_id: attribute.id)

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

  def create_annotation(annotation, top_level)
    start_time = transcript_items.find{|i| i.begin_offset >= annotation.begin_offset}.start_time
    end_time = transcript_items.reverse.find{|i| i.end_offset <= annotation.end_offset}.end_time
    if Annotation.exists?(aws_id: annotation.id)
      curr_annotation = Annotation.find_by(aws_id: annotation.id)
      if curr_annotation.top == false && top_level
        curr_annotation.update_attribute(:top, top_level)
      end
    else
      Annotation.create(
        recording: self,
        category: annotation.category,
        begin_offset: annotation.begin_offset,
        end_offset: annotation.end_offset,
        text: annotation.text,
        kind: annotation.type,
        aws_id: annotation.id,
        start_time: start_time,
        end_time: end_time,
        top: top_level,
      )
    end
    curr_annotation = Annotation.find_by(aws_id: annotation.id)

    unless annotation.traits.blank?
      annotation.traits.each do |t|
        AnnotationTrait.create(
          annotation: curr_annotation,
          score: t.score,
          name: t.name
        )
      end
    end
  end
end
