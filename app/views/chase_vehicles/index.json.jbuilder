json.array!(@chase_vehicles) do |chase_vehicle|
  json.extract! chase_vehicle, :description, :ident, :mission, :location_device, :beacon_receivers, :ground_track
  json.url chase_vehicle_url(chase_vehicle, format: :json)
end
