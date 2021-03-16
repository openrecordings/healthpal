class AddCreatedAsCaregiverToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :created_as_caregiver, :boolean
  end
end
