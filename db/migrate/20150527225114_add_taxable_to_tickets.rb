class AddTaxableToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :taxable, :boolean
    add_column :tickets, :tax_exemption, :string
    Ticket.find_each do |ticket|
        ticket.taxable = true;
        ticket.save!
    end
  end
end
