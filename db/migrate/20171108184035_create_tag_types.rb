class CreateTagTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :tag_types do |t|
      t.text :label

      t.timestamps
    end
  end
end
