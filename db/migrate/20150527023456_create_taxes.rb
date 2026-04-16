class CreateTaxes < ActiveRecord::Migration[5.2]
  def change
    create_table :taxes do |t|
      t.decimal :rate
      t.string :name
      t.datetime :date_enabled
      t.datetime :date_retired
      t.string :region

      t.timestamps
    end
  end
end
