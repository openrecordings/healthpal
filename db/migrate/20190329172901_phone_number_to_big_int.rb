class PhoneNumberToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :phone_number, :bigint
  end
end
