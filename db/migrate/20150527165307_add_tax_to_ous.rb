class AddTaxToOus < ActiveRecord::Migration[5.2]
  def change
    add_reference :ous, :tax, index: true
  end
end
