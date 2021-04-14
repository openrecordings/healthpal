class AddCanViewTagsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :can_view_tags, :boolean
  end
end
