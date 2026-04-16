class CreateTicketExpenses < ActiveRecord::Migration[5.2]
	def change
		create_table :ticket_expenses do |t|
			t.references :ticket, foreign_key: true
			t.references :expense_type, foreign_key: true
			t.references :employee, foreign_key: true
			t.decimal :cost, precision: 16, scale: 2
			t.string :note
			t.datetime :date_incurred

			t.timestamps
		end

	end
end
