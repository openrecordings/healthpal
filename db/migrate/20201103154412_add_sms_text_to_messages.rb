class AddSmsTextToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :sms_text_function, :string
  end
end
