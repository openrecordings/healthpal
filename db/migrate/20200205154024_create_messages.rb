class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :recording
      t.references :message_template
      t.datetime :deliver_at
      t.boolean :deliver
      t.datetime :delivered_at
      t.boolean :to_email
      t.boolean :to_sms
      t.timestamps
    end
  end
end
