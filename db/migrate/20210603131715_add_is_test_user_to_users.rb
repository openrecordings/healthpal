class AddIsTestUserToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_test_user, :boolean
  end
end
