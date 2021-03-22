class AddTextFieldToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :text, :string
  end
end
