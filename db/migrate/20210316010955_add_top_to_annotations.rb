class AddTopToAnnotations < ActiveRecord::Migration[6.0]
  def change
    add_column :annotations, :top, :boolean
  end
end
