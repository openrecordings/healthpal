class AddTextFieldToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :text, :string
  end
end
