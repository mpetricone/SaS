class AddTaxRateToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :tax_rate, :string
  end
end
