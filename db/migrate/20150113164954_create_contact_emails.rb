class CreateContactEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_emails do |t|
      t.string :address
      t.belongs_to :contact, index: true

      t.timestamps
    end
  end
end
