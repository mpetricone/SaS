class CreateTicketActionStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_action_statuses do |t|
      t.string :status

      t.timestamps
    end
  end
end
