class AddDatePayedToExpensePayments < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_payments, :date_payed, :date
  end
end
