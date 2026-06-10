class CreateQuoteLabors < ActiveRecord::Migration[8.1]
  def change
    create_table :quote_labors do |t|
      t.bigint  :quote_id,    null: false
      t.bigint  :rate_id
      t.string  :description, null: false
      t.integer :billing,     null: false, default: 0
      t.string  :amount
      t.decimal :estimated_hours, precision: 8, scale: 2

      t.timestamps
    end

    add_index :quote_labors, :quote_id
    add_index :quote_labors, :rate_id
  end
end
