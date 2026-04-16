class ChangeAuthentityColumnValdToIsValid < ActiveRecord::Migration[5.2]
  def change
    rename_column :authenticity_tokens, :valid, :is_valid
  end
end
