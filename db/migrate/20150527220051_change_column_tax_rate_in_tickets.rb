class ChangeColumnTaxRateInTickets < ActiveRecord::Migration[5.2]
  def change
      change_column :tickets, :tax_rate, :decimal, precision: 16, scale: 2
  end
end
