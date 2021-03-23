class MakeAnnotationsChildrenOfTranscriptSegments < ActiveRecord::Migration[6.0]
  def change
    rename_column :annotations, :recording_id, :transcript_segment_it
  end
end
