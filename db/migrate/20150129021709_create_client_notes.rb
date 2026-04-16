class CreateClientNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :client_notes do |t|
      t.references :client, index: true
      t.text :note
      t.string :title

      t.timestamps
    end
  end
end
