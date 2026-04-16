json.array!(@expense_payments) do |expense_payment|
  json.extract! expense_payment, :id, :amount, :identifier, :ou_payment_type_id, :expense_id
  json.url expense_payment_url(expense_payment, format: :json)
end
