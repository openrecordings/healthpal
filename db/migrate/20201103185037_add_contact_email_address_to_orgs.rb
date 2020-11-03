class AddContactEmailAddressToOrgs < ActiveRecord::Migration[6.0]
  def change
    add_column :orgs, :contact_email_address, :string
  end
end
