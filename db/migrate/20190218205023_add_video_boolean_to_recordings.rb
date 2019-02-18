class AddVideoBooleanToRecordings < ActiveRecord::Migration[5.2]
  def change
    add_column :recordings, :video, :boolean
  end
end
