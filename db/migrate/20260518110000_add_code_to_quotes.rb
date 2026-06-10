class AddCodeToQuotes < ActiveRecord::Migration[8.1]
  def up
    add_column :quotes, :code, :string
    Quote.reset_column_information
    Quote.where(code: nil).find_each do |q|
      day = ((q.created_at || Time.current).to_date - Date.new(1970, 1, 1)).to_i
      loop do
        suffix = SecureRandom.alphanumeric(6).upcase
        candidate = "Q#{day}-#{suffix}"
        unless Quote.exists?(code: candidate)
          q.update_columns(code: candidate)
          break
        end
      end
    end
    change_column_null :quotes, :code, false
    add_index :quotes, :code, unique: true
  end

  def down
    remove_index :quotes, :code
    remove_column :quotes, :code
  end
end
