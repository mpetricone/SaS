class CreateClientEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :client_emails do |t|
      t.string :email
      t.string :description
      t.references :client, index: true

      t.timestamps
    end
  end
end
