class AddRelatedAnnotationToAnnotationRelationss < ActiveRecord::Migration[6.0]
  def change
    add_column :annotation_relations, :related_annotation_id, :integer
  end
end
