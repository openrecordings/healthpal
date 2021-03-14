class CreateParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :participants do |t|
      t.references :user
      t.references :org
      t.integer :group
      t.datetime :registered_at
      t.timestamps
    end
  end
end
