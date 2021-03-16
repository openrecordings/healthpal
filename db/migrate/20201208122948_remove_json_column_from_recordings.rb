class RemoveJsonColumnFromRecordings < ActiveRecord::Migration[6.0]
  def change
    remove_column :recordings, :json, :transcript_json
    add_column :recordings, :transcript_json, :json
    add_column :recordings, :annotation_json, :json
  end
end
