class CreateUtterances < ActiveRecord::Migration[5.0]
  def change
    create_table :utterances do |t|
      t.integer :transcript_id
      t.integer :index 
      t.integer :begins_at
      t.text :text
      t.timestamps
    end
  end
end
