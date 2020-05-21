class AddForeignKeyToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :org_id, :integer
  end
end
