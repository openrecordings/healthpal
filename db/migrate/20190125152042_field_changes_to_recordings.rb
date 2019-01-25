class FieldChangesToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :original_file_name, :string
    remove_column :recordings, :file_hash
  end
end
