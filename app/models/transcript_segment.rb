class TranscriptSegment < ApplicationRecord
  belongs_to :recording
  has_many :annotations, dependent: :destroy

  validates_presence_of :recording

  default_scope { order(:id) }

  # These are used when merging segements in PlayController#prepare_segments
  attr_accessor :tmp_text
  attr_accessor :tmp_annotation_categories
  attr_accessor :tmp_annotations

  def text
    transcript_items.map{|transcript_item| transcript_item.content}.reduce(:+)
  end

  def annotation_categories
    annotations.map(&:category).uniq
  end

  def links
    []
    #TODO
  end

  private

  # Ignores punctuation
  def transcript_items
    recording.transcript_items.where(kind: 'pronunciation').where('start_time >= ?', start_time).where('end_time <= ?', end_time)
  end
end
