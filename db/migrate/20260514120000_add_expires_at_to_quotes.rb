class AddExpiresAtToQuotes < ActiveRecord::Migration[8.1]
  def up
    add_column :quotes, :expires_at, :datetime
    Quote.reset_column_information
    Quote.where(expires_at: nil).find_each do |q|
      base = q.created_at || Time.current
      q.update_columns(expires_at: base + 2.weeks)
    end
    add_index :quotes, :expires_at
  end

  def down
    remove_index :quotes, :expires_at
    remove_column :quotes, :expires_at
  end
end
