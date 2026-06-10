class CreateQuoteProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :quote_products do |t|
      t.bigint  :quote_id,   null: false
      t.bigint  :product_id, null: false
      t.string  :price
      t.integer :quantity

      t.timestamps
    end

    add_index :quote_products, :quote_id
    add_index :quote_products, :product_id
  end
end
