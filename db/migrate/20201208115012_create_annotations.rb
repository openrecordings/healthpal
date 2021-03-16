class CreateAnnotations < ActiveRecord::Migration[6.0]
  def change
    create_table :annotations do |t|
      t.references :recording
      t.integer :begin_offset
      t.integer :end_offset
      t.float :score
      t.string :text
      t.string :category
      t.string :kind
      t.json :traits
      t.json :sub_annotations
      t.timestamps
    end
  end
end
