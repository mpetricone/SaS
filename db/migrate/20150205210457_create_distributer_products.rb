class CreateDistributerProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :distributer_products do |t|
      t.references :distributer, index: true
      t.references :product, index: true
      t.string :current_cost
      t.string :dist_item_number

      t.timestamps
    end
  end
end
