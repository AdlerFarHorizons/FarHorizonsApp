json.array!(@chase_servers) do |chase_server|
  json.extract! chase_server, :hostname, :make, :model, :serial_no, :sw_version, :location_device_id, :beacon_receiver_ids, :router_id, :persistent
  json.url chase_server_url(chase_server, format: :json)
end
