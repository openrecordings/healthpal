# A top-level annotation reord from AWS Comprehend Medical
class Annotation < ApplicationRecord
  belongs_to :transcript_segment
  has_many :annotation_relations, dependent: :destroy
  has_many :annotation_traits, dependent: :destroy

  validates_presence_of :transcript_segment, :category, :begin_offset, :end_offset, :start_time, :end_time, :text, :kind, :aws_id

end
