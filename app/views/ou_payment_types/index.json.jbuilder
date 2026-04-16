json.array!(@ou_payment_types) do |ou_payment_type|
  json.extract! ou_payment_type, :id, :name, :date_enabled, :date_retired, :method, :info, :ou_id
  json.url ou_payment_type_url(ou_payment_type, format: :json)
end
