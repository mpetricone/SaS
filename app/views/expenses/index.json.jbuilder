json.array!(@expenses) do |expense|
  json.extract! expense, :id, :name, :cost, :date_incurred, :description, :paid, :invoice_number, :ou_id, :employee_id, :expense_type_id
  json.url expense_url(expense, format: :json)
end
