class AddTaxableLaborToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :taxable_labor, :boolean
    Ticket.find_each do |ticket|
        ticket.taxable_labor = true
        ticket.save!
    end
  end
end
