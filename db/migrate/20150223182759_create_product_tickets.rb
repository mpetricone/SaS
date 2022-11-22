class CreateProductTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :product_tickets do |t|
      t.references :ticket, index: true
      t.references :product, index: true
      t.datetime :date_sold
      t.string :price

      t.timestamps
    end
  end
end
