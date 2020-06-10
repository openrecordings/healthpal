class AddTimeToUserField < ActiveRecord::Migration[6.0]
  def change
    add_column :user_fields, :at, :float 
    rename_column :user_fields, :type, :kind
  end
end
