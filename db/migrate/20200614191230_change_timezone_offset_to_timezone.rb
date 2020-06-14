class ChangeTimezoneOffsetToTimezone < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :timezone_offset
    add_column :users, :timezone, :string 
  end
end
