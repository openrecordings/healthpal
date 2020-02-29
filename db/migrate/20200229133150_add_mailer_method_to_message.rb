class AddMailerMethodToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :mailer_method, :string
  end
end
