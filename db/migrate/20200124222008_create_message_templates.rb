class CreateMessageTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :message_templates do |t|
      t.string :text 
      t.integer :trigger
      t.string :offset_duration
      t.timestamps
    end
  end
end
