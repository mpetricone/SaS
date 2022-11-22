class CreateClientPhones < ActiveRecord::Migration[5.2]
  def change
    create_table :client_phones do |t|
      t.string :number
      t.string :description
      t.references :client, index: true

      t.timestamps
    end
  end
end
