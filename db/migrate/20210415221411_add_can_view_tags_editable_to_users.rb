class AddCanViewTagsEditableToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :can_view_tags_editable, :boolean
  end
end
