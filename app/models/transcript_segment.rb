class TranscriptSegment < ApplicationRecord
  belongs_to :recording
  has_many :annotations, dependent: :destroy

  validates_presence_of :recording

  default_scope { order(:id) }

  # Thse are used when merging segements in PlayController#prepare_segments
  attr_accessor :tmp_text
  attr_accessor :tmp_annotation_categories
  attr_accessor :tmp_annotations

  def text
    transcript_items.map{|transcript_item| transcript_item.content}.reduce(:+)
  end
  
  def annotation_categories
    categories = []
    self.annotations.each do |annotation|
      categories << annotation.category
    end
    categories.uniq
  end

  def links
    []
    #TODO
  end

  private

  # Ignores punctuation
  def transcript_items
    recording.transcript_items.select{|item| item.kind == 'pronunciation' && item.start_time >= start_time && item.end_time <= end_time}
  end
end
