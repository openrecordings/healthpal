class AddTimezoneOffsetToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :timezone_offset, :integer
  end
end
