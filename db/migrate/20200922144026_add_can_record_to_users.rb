class AddCanRecordToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :can_record, :boolean
  end
end
