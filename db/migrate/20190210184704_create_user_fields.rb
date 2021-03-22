class CreateUserFields < ActiveRecord::Migration[6.0]
  def change
    create_table :user_fields do |t|
      t.integer :user_id
      t.string :text
      t.timestamps
    end
  end
end
