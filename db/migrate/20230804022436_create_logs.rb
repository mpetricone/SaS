class CreateLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :logs do |t|
      t.text :command
      t.text :category
      t.string :module_name
      t.string :in_method
      t.text :details
      t.references :employee, foreign_key: true, null: true, default: :null
      t.datetime :issued_at
      t.datetime :event_at
      t.datetime :ack_at

      t.timestamps
    end
  end
end
