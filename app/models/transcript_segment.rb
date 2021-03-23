class TranscriptSegment < ApplicationRecord
  belongs_to :recording
  has_many :annotations, dependent: :destroy

  validates_presence_of :recording

  default_scope { order(:id) }

  def text
    transcript_items.map{|transcript_item| transcript_item.content}.reduce(:+)
  end

  private

  # Ignores punctuation
  def transcript_items
    recording.transcript_items.select{|item| item.kind == 'pronunciation' && item.start_time >= start_time && item.end_time <= end_time}
  end
end
