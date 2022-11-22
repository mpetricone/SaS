class CreateDistributerPhones < ActiveRecord::Migration[5.2]
  def change
    create_table :distributer_phones do |t|
      t.references :distributer, index: true
      t.string :number
      t.string :description

      t.timestamps
    end
  end
end
