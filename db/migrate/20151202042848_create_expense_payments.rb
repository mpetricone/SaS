class CreateExpensePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_payments do |t|
      t.string :amount
      t.string :identifier
      t.references :ou_payment_type, index: true
      t.references :expense, index: true

      t.timestamps
    end
  end
end
