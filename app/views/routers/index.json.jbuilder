json.array!(@routers) do |router|
  json.extract! router, :id, :make, :model, :serial_no, :address, :ssid, :persistent
  json.url router_url(router, format: :json)
end
