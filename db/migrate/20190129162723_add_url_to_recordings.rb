class AddUrlToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :url, :string
  end
end
