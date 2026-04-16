class CreateProductNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :product_notes do |t|
      t.references :product, index: true
      t.string :title
      t.text :note

      t.timestamps
    end
  end
end
