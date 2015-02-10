json.array!(@beacon_receivers) do |beacon_receiver|
  json.extract! beacon_receiver, :make, :model, :serial_no, :driver, :driver_pid :port, :persistent
  json.url beacon_receiver_url(beacon_receiver, format: :json)
end
