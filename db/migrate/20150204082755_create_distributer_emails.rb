class CreateDistributerEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :distributer_emails do |t|
      t.references :distributer
      t.string :email
      t.string :description

      t.timestamps
    end
  end
end
