class AddAnnotationRefToAnnotationTraits < ActiveRecord::Migration[6.0]
  def change
    add_reference :annotation_traits, :annotation, null: false, foreign_key: true
  end
end
