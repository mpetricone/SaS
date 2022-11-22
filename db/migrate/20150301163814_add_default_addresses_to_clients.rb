class AddDefaultAddressesToClients < ActiveRecord::Migration[5.2]
  def change
      add_column :clients, :default_invoice_id, :integer, index: true
      add_column :clients, :default_delivery_id, :integer, index: true
  end
end
