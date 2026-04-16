class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :client, index: true
      t.references :contact, index: true
      t.references :employee, index: true
      t.references :rate, index: true
      t.references :ticket_status, index: true
      t.string :cost_parts
      t.datetime :date_created
      t.datetime :date_resolved
      t.string :short_description
      t.boolean :billing_hourly
      t.boolean :billing_fixed
      t.string :billing_fixed_value
      t.boolean :payment_requested
      t.boolean :payment_received
      t.datetime :invoice_date


      t.timestamps
    end
  end
end
