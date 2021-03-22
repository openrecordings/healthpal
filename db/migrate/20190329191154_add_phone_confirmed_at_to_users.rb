class AddPhoneConfirmedAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :phone_confirmed_at, :datetime 
    add_column :users, :phone_token, :integer
    add_column :users, :requires_phone_confirmation, :boolean
  end
end
