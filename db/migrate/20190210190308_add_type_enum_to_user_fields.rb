class AddTypeEnumToUserFields < ActiveRecord::Migration[6.0]
  def change
    add_column :user_fields, :type, :integer
  end
end
