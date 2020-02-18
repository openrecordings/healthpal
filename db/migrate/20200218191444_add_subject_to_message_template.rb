class AddSubjectToMessageTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :message_templates, :subject, :string
  end
end
