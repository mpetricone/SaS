class CreateContactPhones < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_phones do |t|
      t.string :number
      t.string :phone_type
      t.belongs_to :contact, index: true

      t.timestamps
    end
  end
end
