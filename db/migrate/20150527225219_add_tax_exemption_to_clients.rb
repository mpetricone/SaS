class AddTaxExemptionToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :tax_exemption, :string
  end
end
