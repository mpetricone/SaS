class CreateAddressClients < ActiveRecord::Migration[5.2]
  def change
    create_table :address_clients do |t|
      t.references :address, index: true
      t.references :client, index: true
      t.boolean :delivery
      t.boolean :invoice
      t.timestamps
    end
  end
end
