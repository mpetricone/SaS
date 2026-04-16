json.array!(@standings) do |standing|
  json.extract! standing, :id, :name
  json.url standing_url(standing, format: :json)
end
