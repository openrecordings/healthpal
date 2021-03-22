class AddUrlToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :url, :string
  end
end
