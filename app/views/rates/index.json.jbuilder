json.array!(@rates) do |rate|
  json.extract! rate, :id, :rate, :current, :date_implemented, :date_retired, :client_rates
  json.url rate_url(rate, format: :json)
end
