class UserFieldsBelongToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :user_fields, :recording_id, :integer
    remove_column :user_fields, :user_id
  end
end
