class CreateTicketPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_payments do |t|
      t.references :ticket, index: true
      t.string :payment
      t.date :date_received

      t.timestamps
    end
  end
end
