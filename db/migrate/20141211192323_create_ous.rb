class CreateOus < ActiveRecord::Migration[5.2]
  def change
    create_table :ous do |t|
      t.string :name
      t.text :description
      t.references :root

      t.timestamps
    end
  end
end
