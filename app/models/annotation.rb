# A top-level annotation reord from AWS Comprehend Medical
class Annotation < ApplicationRecord
  belongs_to :transcript_segment
  has_many :annotation_relations, dependent: :destroy
  has_many :annotation_traits, dependent: :destroy

  validates_presence_of :recording, :category, :begin_offset, :end_offset, :start_time, :end_time, :text, :kind, :aws_id

  def segment_text
    transcript_items.map{|transcript_item| transcript_item.content}.reduce(:+)
  end

  private

  def transcript_items
    transcript_segment = recording.transcript_segments.find{|segment| segment.end_time >= end_time}
    recording.transcript_items.select{|item| item.kind == 'pronunciation' && item.start_time >= transcript_segment.start_time && item.end_time <= transcript_segment.end_time}
  end

end
