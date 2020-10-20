class Recording < ApplicationRecord
  belongs_to :user
  has_many :utterances, -> {order 'index asc'}, dependent: :destroy
  has_many :recording_notes, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_one_attached :media_file
  visitable :ahoy_visit

  # Add all supported transcription services here
  # TODO: Add old Acusis code back in after getting gcloud going?
  enum source: [:google, :aws]

  validates_presence_of :title

  scope :processed, -> {where(is_processed: true)}

  def transcribe
    # TRANSCRIPTION DISABLED FOR R56
    # TranscribeAwsJob.perform_later(self)
  end

  def notes
    recording_notes
  end

  # Transcript upload (Acusis)
  #################################################################################################
  attr_accessor :transcript_txt_file

  ACUSIS_RAW_TIMESTAMP = /\A\d\d:\d\d/
  ACUSIS_PERSON_ID = /\APERSON [A-Z]:/

  def build_utterances
    # Destroy any existing utterances for self (user was warned)
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
end
