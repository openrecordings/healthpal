class RemoveOtpColumnsFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :otp_auth_secret
    remove_column :users, :otp_recovery_secret
    remove_column :users, :otp_enabled
    remove_column :users, :otp_mandatory
    remove_column :users, :otp_enabled_on
    remove_column :users, :otp_failed_attempts
    remove_column :users, :otp_recovery_counter
    remove_column :users, :otp_persistence_seed
    remove_column :users, :otp_session_challenge
    remove_column :users, :otp_challenge_expires
  end
end
