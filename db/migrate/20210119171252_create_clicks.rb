class CreateClicks < ActiveRecord::Migration[6.0]
  def change
    create_table :clicks do |t|
      t.integer :user_id
      t.integer :recording_id
      t.string :element_id
      t.string :client_ip_address
      t.string :url_when_clicked
      t.timestamps
    end
  end
end
