class ChangeTranscriptItemsCountName < ActiveRecord::Migration[6.0]
  def change
    rename_column :transcript_items, :count, :transcript_chunk
  end
end
