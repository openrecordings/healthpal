class CreateRecordingNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :recording_notes do |t|
      t.references :recording
      t.string :text
      t.float :at
      t.timestamps
    end
  end
end
