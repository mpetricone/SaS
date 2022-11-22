class AddAdminToPermission < ActiveRecord::Migration[5.2]
  def change
    add_column :permissions, :admin, :boolean
  end
end
