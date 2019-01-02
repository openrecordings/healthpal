class UserNotesToRecordings < ActiveRecord::Migration[5.2]
  def change
    remove_reference :user_notes, :user
    add_reference :user_notes, :recording
  end
end
