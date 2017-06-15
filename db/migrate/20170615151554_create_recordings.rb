class CreateRecordings < ActiveRecord::Migration[5.0]
  def change
    create_table :recordings do |t|
      t.integer :user_id
      t.string :filetype
      t.binary :audio
      t.timestamps
    end
  end
end
