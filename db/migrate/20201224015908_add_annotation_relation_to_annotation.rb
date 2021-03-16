class AddAnnotationRelationToAnnotation < ActiveRecord::Migration[6.0]
  def change
    add_reference :annotation_relations, :annotation
  end
end
