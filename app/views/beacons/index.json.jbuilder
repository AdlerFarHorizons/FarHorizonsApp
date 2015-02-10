json.array!(@beacons) do |beacon|
  json.extract! beacon, :make, :model, :serial_no, :ident, :persistent
  json.url beacon_url(beacon, format: :json)
end
