class AddedCharacterOffsetsToTranscriptItems < ActiveRecord::Migration[6.0]
  def change
    add_column :transcript_items, :begin_offset, :integer
    add_column :transcript_items, :end_offset, :integer
  end
end
