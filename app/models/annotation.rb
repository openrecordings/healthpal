# A top-level annotation reord from AWS Comprehend Medical
class Annotation < ApplicationRecord
  belongs_to :recording
  has_many :annotation_relations, dependent: :destroy
  has_many :annotation_traits, dependent: :destroy

  validates_presence_of :recording, :category, :begin_offset, :end_offset, :text, :kind, :aws_id

end
