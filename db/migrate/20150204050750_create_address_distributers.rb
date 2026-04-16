class CreateAddressDistributers < ActiveRecord::Migration[5.2]
  def change
    create_table :address_distributers do |t|
      t.references :address, index: true
      t.references :distributer, index: true
      t.boolean :invoice
      t.boolean :delivery

      t.timestamps
    end
  end
end
