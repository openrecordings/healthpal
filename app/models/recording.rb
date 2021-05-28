class Recording < ApplicationRecord
  belongs_to :user
  has_many :utterances, -> { order 'index asc' }, dependent: :destroy
  has_many :recording_notes, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :clicks, dependent: :destroy
  has_one_attached :media_file

  # Add all supported transcription services here
  # TODO: Add old Acusis code back in after getting gcloud going?
  enum source: %i[google aws]

  validates_presence_of :title

  scope :processed, -> { where(is_processed: true) }

  def self.user_recordings
    # Recording.all.to_a.select do |r|
    #   r.user.role == 'user'
    # end.sort_by { |r| [r.user.org_id, r.created_at] }
  end

  def transcribe
    TranscribeAwsJob.perform_later(self)
  end

  def notes
    recording_notes
  end

  def total_clicks_on_play
    clicks.where(
      element_id: 'play-pause-button',
      user_id: user.id
    ).count
  end
end
