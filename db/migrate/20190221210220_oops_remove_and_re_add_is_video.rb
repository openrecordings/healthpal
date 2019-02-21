class OopsRemoveAndReAddIsVideo < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :recordings, :is_video
      add_column :recordings, :is_video, :boolean
    end
  end
end
