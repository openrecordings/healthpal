class AddAhoyVisitToRecordings < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :ahoy_visit_id, :bigint
  end
end
