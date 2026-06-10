class AddReceivesQuotesToClientContacts < ActiveRecord::Migration[8.1]
  def change
    add_column :client_contacts, :receives_quotes, :boolean, null: false, default: false
  end
end
