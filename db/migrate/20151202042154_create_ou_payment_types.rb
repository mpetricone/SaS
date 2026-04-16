class CreateOuPaymentTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ou_payment_types do |t|
      t.string :name
      t.date :date_enabled
      t.date :date_retired
      t.string :method
      t.text :info
      t.references :ou, index: true

      t.timestamps
    end
  end
end
