class DropAuthenticityTokens < ActiveRecord::Migration[8.1]
  def up
    drop_table :authenticity_tokens
  end

  def down
    create_table :authenticity_tokens do |t|
      t.bigint :employee_id
      t.string :token
      t.integer :ttl
      t.boolean :is_valid
      t.string :reason
      t.datetime :time_invalid, precision: nil
      t.timestamps precision: nil
      t.index [:employee_id], name: "index_authenticity_tokens_on_employee_id"
    end
  end
end
