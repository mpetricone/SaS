class AddLaborTimerToTicketTimes < ActiveRecord::Migration[8.1]
  def change
    add_column :ticket_times, :employee_id, :bigint
    add_column :ticket_times, :running, :boolean, default: false, null: false
    add_column :ticket_times, :timer_started_at, :datetime
    add_column :ticket_times, :timer_stopped_at, :datetime
    add_index :ticket_times, :employee_id
    add_index :ticket_times, :running
  end
end
