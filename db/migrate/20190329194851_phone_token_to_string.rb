class PhoneTokenToString < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :phone_token, :string
  end
end
