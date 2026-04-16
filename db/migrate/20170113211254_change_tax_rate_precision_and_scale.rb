class ChangeTaxRatePrecisionAndScale < ActiveRecord::Migration[5.2]
  # this has become and issue because of ludacris NJ tax rates
  def change
    change_column :taxes, :rate, :decimal, precision: 16, scale: 6
  end
end
