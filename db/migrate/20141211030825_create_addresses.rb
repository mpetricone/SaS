class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :street1
      t.string :street2
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.integer :status

      t.timestamps
    end
  end
end
