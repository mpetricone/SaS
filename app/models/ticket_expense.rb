class TicketExpense < ApplicationRecord
	belongs_to :ticket
	belongs_to :expense_type
	belongs_to :employee

	validates_presence_of :ticket
	validates_presence_of :expense_type_id
	validates_presence_of :cost
	validates_presence_of :employee
end
