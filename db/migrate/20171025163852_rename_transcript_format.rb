class RenameTranscriptFormat < ActiveRecord::Migration[5.0]
  def change
    rename_column :transcripts, :format, :source
  end
end
