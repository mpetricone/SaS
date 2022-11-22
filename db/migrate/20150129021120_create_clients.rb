class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :name
      t.references :standing, index: true
      t.boolean :refuse

      t.timestamps
    end
  end
end
