class AddTypeEnumToUserFields < ActiveRecord::Migration[5.2]
  def change
    add_column :user_fields, :type, :integer
  end
end
