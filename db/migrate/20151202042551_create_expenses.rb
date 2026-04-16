class CreateExpenses < ActiveRecord::Migration[5.2]
  def change
    create_table :expenses do |t|
      t.string :name
      t.string :cost
      t.date :date_incurred
      t.text :description
      t.boolean :paid
      t.string :invoice_number
      t.references :ou, index: true
      t.references :employee, index: true
      t.references :expense_type, index: true

      t.timestamps
    end
  end
end
