class CreateTranscripts < ActiveRecord::Migration[5.0]
  def change
    create_table :transcripts do |t|
      t.integer :recording_id
      t.integer :format
      t.text :raw
      t.timestamps
    end
  end
end
