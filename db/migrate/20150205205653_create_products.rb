class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :base_cost
      t.string :item_number  
      t.string :sku
      t.string :name
      t.text :description
      t.string :category
      t.string :manufacturer
      t.timestamps
    end
  end
end
