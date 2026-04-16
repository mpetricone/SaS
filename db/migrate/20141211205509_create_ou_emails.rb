class CreateOuEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :ou_emails do |t|
      t.belongs_to :ou, index: true
      t.string :address

      t.string :description

      t.timestamps
    end
  end
end
