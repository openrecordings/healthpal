class AddUserToMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :messages, :user, null: true, foreign_key: true
  end
end
