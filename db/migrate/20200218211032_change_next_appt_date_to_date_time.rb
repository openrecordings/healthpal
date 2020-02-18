class ChangeNextApptDateToDateTime < ActiveRecord::Migration[6.0]
  def change
    change_column :recordings, :next_appt_date, :datetime

  end
end
