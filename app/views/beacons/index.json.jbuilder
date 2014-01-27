json.array!(@beacons) do |beacon|
  json.extract! beacon, :id, :make, :model, :serial_no, :call_sign, :persistent
  json.url beacon_url(beacon, format: :json)
end
