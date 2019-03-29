class RemoveConfirmableFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :confirmation_token
    remove_column :users, :confirmed_at
    remove_column :users, :confirmation_sent_at
  end
end
