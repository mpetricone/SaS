class ChangeTicketTaxRatePrecisionAndScale < ActiveRecord::Migration[5.2]
  def change
    change_column :tickets, :tax_rate, :decimal, precision: 16, scale: 6
  end
end
