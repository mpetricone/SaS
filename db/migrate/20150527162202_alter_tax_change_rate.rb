class AlterTaxChangeRate < ActiveRecord::Migration[5.2]
  def change
      change_column :taxes, :rate, :decimal, precision: 16 , scale: 2
  end
end
