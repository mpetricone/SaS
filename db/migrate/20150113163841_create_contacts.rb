class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :fname
      t.string :lname
      t.string :mname
      t.string :description
      t.belongs_to :standing

      t.timestamps
    end
  end
end
