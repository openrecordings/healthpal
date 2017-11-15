# Holds the raw transcript for a recording. 
class Transcript < ApplicationRecord
  belongs_to :recording  
  has_many :utterances, -> {order 'index asc'}
  has_many :tags, through: :utterances

  validates_presence_of :recording, :source, :raw
  
  attr_accessor :file

  # Seems somewhat likely that we will have to support more than transcription format
  enum source: [:acusis]

  ACUSIS_RAW_TIMESTAMP = /\A\d\d:\d\d/
  ACUSIS_PERSON_ID = /\APERSON [A-Z]:/

  def process_upload
    raw_from_file
    build_utterances
  end

  # destroy this transcript and all related utterances and tags
  def clean
    self.utterances.each do |utterance|
      utterance.tags.destroy_all
    end
    self.utterances.destroy_all
    self.destroy
  end

  private

  def raw_from_file
    return nil unless (@file.original_filename.ends_with?('.txt')) || ((system 'which unrtf') && @file && source && @file.is_a?(ActionDispatch::Http::UploadedFile))
    if acusis?
      self.raw = (@file.original_filename.ends_with?('.txt'))? @file.read : `unrtf #{@file.tempfile.path} --text`
    else 
      nil
    end
  end

  def build_utterances
    # TODO: This breaks if the recording is longer than 60(100?) minutes!
    # TODO: Assumes Acusis format
    utt = nil
    return nil unless raw
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
          utt.ends_at = begins_at + ((begins_at == utt.begins_at)? 1 : 0)
          self.utterances << utt
        end
        utt = Utterance.new(
          transcript: self,
          index: i,
          begins_at: begins_at,
          text: text,
          ends_at: 0
        )
      end
    end
    if (utt)
      self.utterances << utt
    end
  end

end
