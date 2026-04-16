class AddQuantityToProductTickets < ActiveRecord::Migration[5.2]
  def change
      add_column :product_tickets, :quantity, :integer
  end
end
