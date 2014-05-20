json.array!(@beacons) do |beacon|
  json.extract! beacon, :make, :model, :serial_no, :call_sign, :persistent :point
  json.url beacon_url(beacon, format: :json)
end
