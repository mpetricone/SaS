class CreateAuthenticityTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :authenticity_tokens do |t|
      t.references :employee, foreign_key: true
      t.string :token
      t.datetime :time_invalid
      t.boolean :valid
      t.integer :ttl
      t.string :reason

      t.timestamps
    end
  end
end
