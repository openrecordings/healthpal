class CreateAnnotationRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :annotation_relations do |t|
      t.float :score
      t.string :type
      t.timestamps
    end
  end
end
