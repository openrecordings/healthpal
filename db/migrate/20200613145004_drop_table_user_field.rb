class DropTableUserField < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_fields
  end
end
