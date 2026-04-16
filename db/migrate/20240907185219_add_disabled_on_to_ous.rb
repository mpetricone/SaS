class AddDisabledOnToOus < ActiveRecord::Migration[7.0]
  def change
    add_column :ous, :disabled_on, :datetime, default: nil, null: true
  end
end
