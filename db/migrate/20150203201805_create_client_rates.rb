class CreateClientRates < ActiveRecord::Migration[5.2]
  def change
    create_table :client_rates do |t|
      t.references :client
      t.references :rate
      t.boolean :current
      t.date :date_implemented
      t.date :date_retired

      t.timestamps
    end
  end
end
