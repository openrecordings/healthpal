class RecordingNote < ApplicationRecord

  belongs_to :recording

  before_create :avoid_simultaneity

  # This provides predictable auto-scrolling
  def avoid_simultaneity
    note_ats = recording.recording_notes.map{|note| note.at}
    if note_ats.include? at
      self.at = self.at + 0.001
    end
  end

end
