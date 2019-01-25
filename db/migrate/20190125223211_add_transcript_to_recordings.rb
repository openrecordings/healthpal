class AddTranscriptToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :source, :string
    add_column :recordings, :json, :json
  end
end
