class ExpensePayment < ActiveRecord::Base
  belongs_to :ou_payment_type
  belongs_to :expense
  validates :expense_id, presence: true
  validates :amount, presence: true, numericality: true
end
