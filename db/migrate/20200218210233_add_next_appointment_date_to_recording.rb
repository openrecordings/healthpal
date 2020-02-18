class AddNextAppointmentDateToRecording < ActiveRecord::Migration[6.0]
  def change
    add_column :recordings, :next_appt_date, :date
  end
end
