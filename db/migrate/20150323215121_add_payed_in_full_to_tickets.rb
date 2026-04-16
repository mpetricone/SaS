class AddPayedInFullToTickets < ActiveRecord::Migration[5.2]
  def change
      add_column :tickets, :payed_in_full, :boolean
  end
end
