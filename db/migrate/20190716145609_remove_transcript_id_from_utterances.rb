class RemoveTranscriptIdFromUtterances < ActiveRecord::Migration[6.0]
  def change
    remove_column :utterances, :transcript_id, :integer
  end
end
