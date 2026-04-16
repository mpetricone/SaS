class AddUserValidationToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :user_name, :string 
    add_index :employees, :user_name, name: "index_employees_on_user_name"
    add_column :employees, :password_digest, :string
  end
end
