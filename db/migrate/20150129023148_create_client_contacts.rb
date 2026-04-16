class CreateClientContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :client_contacts do |t|
      t.references :client, index: true
      t.references :contact, index: true

      t.timestamps
    end
  end
end
