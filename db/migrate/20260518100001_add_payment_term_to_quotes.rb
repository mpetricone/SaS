class AddPaymentTermToQuotes < ActiveRecord::Migration[8.1]
  def change
    add_column :quotes, :payment_term_id, :bigint
    add_column :quotes, :payment_terms_override, :text
    add_index  :quotes, :payment_term_id
  end
end
