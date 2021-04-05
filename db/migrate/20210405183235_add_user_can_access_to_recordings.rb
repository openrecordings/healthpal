class AddUserCanAccessToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :user_can_access, :boolean
  end
end
