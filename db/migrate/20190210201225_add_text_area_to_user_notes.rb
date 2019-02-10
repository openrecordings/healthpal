class AddTextAreaToUserNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :user_fields, :text_area, :boolean
  end
end
