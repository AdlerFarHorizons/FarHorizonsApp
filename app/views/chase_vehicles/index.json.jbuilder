json.array!(@chase_vehicles) do |chase_vehicle|
  json.extract! chase_vehicle, :id, :description, :identifier, :chase_server_id
  json.url chase_vehicle_url(chase_vehicle, format: :json)
end
