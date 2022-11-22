class CreateTicketInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_infos do |t|
      t.references :ticket, index: true
      t.references :employee, index: true
      t.text :info

      t.timestamps
    end
  end
end
