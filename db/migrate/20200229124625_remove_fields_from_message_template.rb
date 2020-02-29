class RemoveFieldsFromMessageTemplate < ActiveRecord::Migration[6.0]
  def change
    remove_column :message_templates, :text, :string
    remove_column :message_templates, :subject, :string
  end
end
