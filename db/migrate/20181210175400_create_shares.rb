class CreateShares < ActiveRecord::Migration[6.0]
  def change
    create_table :shares do |t|
      t.references :user
      t.string :shared_with_user_id
      t.datetime :revoked_at
      t.timestamps
    end
  end
end
