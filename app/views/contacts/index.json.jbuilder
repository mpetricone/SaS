json.array!(@contacts) do |contact|
  json.extract! contact, :id, :fname, :lname, :mname, :description
  json.url contact_url(contact, format: :json)
end
