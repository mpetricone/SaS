class CreateTicketWorkTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_work_types do |t|
      t.references :ticket, index: true
      t.references :work_type, index: true

      t.timestamps
    end
  end
end
