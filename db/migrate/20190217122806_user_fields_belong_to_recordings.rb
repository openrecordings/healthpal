class UserFieldsBelongToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :user_fields, :recording_id, :integer
    remove_column :user_fields, :user_id
  end
end
