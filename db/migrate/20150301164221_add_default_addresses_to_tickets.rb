class AddDefaultAddressesToTickets < ActiveRecord::Migration[5.2]
  def change
      add_column :tickets, :default_invoice_id, :integer, index: true
      add_column :tickets, :default_delivery_id, :integer, index: true
  end
end
