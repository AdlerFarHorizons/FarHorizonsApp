json.array!(@beacon_receivers) do |beacon_receiver|
  json.extract! beacon_receiver, :make, :model, :serial_no, :driver, :port
  json.url beacon_receiver_url(beacon_receiver, format: :json)
end
