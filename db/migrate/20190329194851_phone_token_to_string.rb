class PhoneTokenToString < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :phone_token, :string
  end
end
