class CreateAddressContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :address_contacts do |t|
      t.references :contact, index: true
      t.references :address, index: true
      t.boolean :delivery
      t.boolean :invoice

      t.timestamps
    end
  end
end
