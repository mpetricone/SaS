class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.boolean :read_record
      t.boolean :write_record
      t.boolean :create_record
      t.boolean :delete_record
      t.string :name
      t.string :object_name

      t.timestamps
    end
    add_index :permissions, :name, unique: true
    add_index :permissions, :object_name
  end
end
