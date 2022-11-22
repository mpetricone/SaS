class CreateTicketTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_times do |t|
      t.references :ticket, index: true
      t.date :date
      t.time :time_start
      t.time :time_end
      t.string :hours

      t.timestamps
    end
  end
end
