class ChangeRelationTypeColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :annotation_relations, :type, :kind

  end
end
