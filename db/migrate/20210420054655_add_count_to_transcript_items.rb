class AddCountToTranscriptItems < ActiveRecord::Migration[6.0]
  def change
    add_column :transcript_items, :count, :integer
  end
end
