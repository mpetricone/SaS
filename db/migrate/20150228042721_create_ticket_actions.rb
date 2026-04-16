class CreateTicketActions < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_actions do |t|
      t.references :ticket, index: true
      t.references :action_status, index: true
      t.references :employee, index: true
      t.datetime :date_taken
      t.string :action

      t.timestamps
    end
  end
end
