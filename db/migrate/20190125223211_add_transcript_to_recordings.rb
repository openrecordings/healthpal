class AddTranscriptToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :source, :string
    add_column :recordings, :json, :json
  end
end
