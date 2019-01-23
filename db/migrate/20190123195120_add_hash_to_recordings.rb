class AddHashToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :file_hash, :string 
  end
end
