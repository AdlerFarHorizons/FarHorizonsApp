json.array!(@platform_servers) do |platform_server|
  json.extract! platform_server, :hostname, :make, :model, :serial_no, :sw_version, :persistent
  json.url platform_server_url(platform_server, format: :json)
end
