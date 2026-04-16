class AddTaxableLaborToTickets < ActiveRecord::Migration[5.2]
  def change
    unless column_exists? :tickets, :taxable_labor
      add_column :tickets, :taxable_labor, :boolean
      Ticket.find_each do |ticket|
        ticket.taxable_labor = true
        ticket.save!
      end
    end
  end
end
