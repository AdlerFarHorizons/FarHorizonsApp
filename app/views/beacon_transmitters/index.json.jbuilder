json.array!(@beacon_transmitters) do |beacon_transmitter|
  json.extract! beacon_transmitter, :make, :model, :serial_no, :driver, :port, :call_sign, :persistent
  json.url beacon_transmitter_url(beacon_transmitter, format: :json)
end
