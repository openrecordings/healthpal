class AddFieldsToLinks < ActiveRecord::Migration[6.0]
  def change
    add_column :links, :label, :string
    add_column :links, :url, :string
  end
end
