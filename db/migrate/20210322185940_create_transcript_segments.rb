class CreateTranscriptSegments < ActiveRecord::Migration[6.0]
  def change
    create_table :transcript_segments do |t|
      t.references :recording
      t.float :start_time
      t.float :end_time
      t.string :speaker_label
      t.timestamps
    end
  end
end
