class AddSaleCostToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :sale_cost, :string
  end
end
