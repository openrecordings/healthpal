class CreateUserNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_notes do |t|
      t.references :user
      t.string :text
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
