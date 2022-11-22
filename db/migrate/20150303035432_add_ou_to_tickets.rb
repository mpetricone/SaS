class AddOuToTickets < ActiveRecord::Migration[5.2]
  def change
    add_reference :tickets, :ou, index: true
  end
end
