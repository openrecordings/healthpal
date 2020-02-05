class AddMessagingBooleansToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email_notifications, :boolean
    add_column :users, :sms_notifications, :boolean
  end
end
