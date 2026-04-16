class AddOuAddressToTickets < ActiveRecord::Migration[5.2]
  def change
      add_column :tickets, :ou_address_id, :integer, index: true
  end
end
