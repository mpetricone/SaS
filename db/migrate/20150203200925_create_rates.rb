class CreateRates < ActiveRecord::Migration[5.2]
  def change
    create_table :rates do |t|
      t.string :rate
      t.boolean :current
      t.date :date_implemented
      t.date :date_retired

      t.timestamps
    end
  end
end
