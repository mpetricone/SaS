class CreateQuotes < ActiveRecord::Migration[8.1]
  def change
    create_table :quotes do |t|
      t.bigint  :client_id,           null: false
      t.bigint  :contact_id
      t.bigint  :ou_id,               null: false
      t.bigint  :rate_id
      t.bigint  :employee_id
      t.string  :title
      t.text    :description
      t.integer :status,              null: false, default: 0
      t.datetime :sent_at
      t.datetime :accepted_at
      t.datetime :declined_at
      t.datetime :completed_at
      t.boolean :taxable,             null: false, default: false
      t.boolean :taxable_labor,       null: false, default: false
      t.decimal :tax_rate, precision: 16, scale: 6, default: 0
      t.bigint  :converted_ticket_id
      t.bigint  :parent_quote_id

      t.timestamps
    end

    add_index :quotes, :client_id
    add_index :quotes, :contact_id
    add_index :quotes, :ou_id
    add_index :quotes, :rate_id
    add_index :quotes, :employee_id
    add_index :quotes, :converted_ticket_id
    add_index :quotes, :parent_quote_id
    add_index :quotes, :status
  end
end
