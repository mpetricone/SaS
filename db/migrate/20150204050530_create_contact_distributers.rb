class CreateContactDistributers < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_distributers do |t|
      t.references :contact, index: true
      t.references :distributer, index: true
      t.string :description

      t.timestamps
    end
  end
end
