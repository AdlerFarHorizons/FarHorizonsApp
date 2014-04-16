json.array!(@routers) do |router|
  json.extract! router, :make, :model, :serial_no, :address, :ssid, :persistent
  json.url router_url(router, format: :json)
end
