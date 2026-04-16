class AddTaxIdToTickets < ActiveRecord::Migration[5.2]
	def change
		add_reference :tickets, :tax, foreign_key: { to_table: :taxes }
	end
end
