class AddPatientIdToRecordings < ActiveRecord::Migration[5.0]
  def change
    add_column :recordings, :patient_identifier, :string
  end
end
