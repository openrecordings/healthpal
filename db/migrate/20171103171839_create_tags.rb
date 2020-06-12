class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table :tags do |t|
      t.references :utterance
      t.string :label
      t.timestamps
    end
  end
end
