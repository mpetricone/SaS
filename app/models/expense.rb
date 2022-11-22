class Expense < ActiveRecord::Base
  belongs_to :ou
  belongs_to :employee
  belongs_to :expense_type
  has_many :expense_payments
  validates :name, presence: true
  validates :cost, presence: true, numericality: true
  validates :date_incurred, presence: true
  validates :ou_id, presence: true
  validates :expense_type_id, presence: true
  validates :employee_id, presence: true

  def calculateAmountPayed
    total = 0
    expense_payments.each do |p|
      total += p.amount
    end
    return total
  end
end
