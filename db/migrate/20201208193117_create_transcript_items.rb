class CreateTranscriptItems < ActiveRecord::Migration[6.0]
  def change
    create_table :transcript_items do |t|
      t.references :recording
      t.float :start_time
      t.float :end_time
      t.string :kind
      t.string :content
      t.timestamps
    end
  end
end
