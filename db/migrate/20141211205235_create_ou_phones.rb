class CreateOuPhones < ActiveRecord::Migration[5.2]
  def change
    create_table :ou_phones do |t|
      t.belongs_to :ou
      t.string :number

      t.string :description

      t.timestamps
    end
  end
end
