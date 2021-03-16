class CreateAnnotationTraits < ActiveRecord::Migration[6.0]
  def change
    create_table :annotation_traits do |t|
      t.string :name
      t.float :score
      t.timestamps
    end
  end
end
