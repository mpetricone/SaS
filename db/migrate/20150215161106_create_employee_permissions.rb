class CreateEmployeePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_permissions do |t|
      t.references :employee, index: true
      t.references :permission, index: true

      t.timestamps
    end
  end
end
