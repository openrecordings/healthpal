class AddFieldsToLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :links, :label, :string
    add_column :links, :url, :string
  end
end
