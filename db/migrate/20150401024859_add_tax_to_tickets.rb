class AddTaxToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :tax, :string
  end
end
