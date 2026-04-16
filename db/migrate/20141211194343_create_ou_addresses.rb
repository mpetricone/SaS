class CreateOuAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :ou_addresses do |t|
      t.belongs_to :ou
      t.belongs_to :address
      t.boolean :delivery
      t.boolean :invoice

      t.timestamps
    end
  end
end
