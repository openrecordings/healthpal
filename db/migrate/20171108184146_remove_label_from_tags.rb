class RemoveLabelFromTags < ActiveRecord::Migration[5.0]
  def change
    remove_column :tags, :label, :string
    add_reference :tags, :tag_type, foreign_key: true
  end
end
