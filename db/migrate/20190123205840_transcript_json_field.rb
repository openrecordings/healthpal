class TranscriptJsonField < ActiveRecord::Migration[5.2]
  def change
    add_column :transcripts, :json, :json
    remove_column :transcripts, :raw
  end
end
