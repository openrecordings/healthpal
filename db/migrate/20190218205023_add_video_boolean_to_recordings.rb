class AddVideoBooleanToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :video, :boolean
  end
end
