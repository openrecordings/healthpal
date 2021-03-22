class AddHashToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :file_hash, :string 
  end
end
