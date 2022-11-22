class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.references :contact, index: true
      t.references :ou, index: true
      t.date :date_hired
      t.string :position

      t.timestamps
    end
  end
end
