json.array!(@location_devices) do |location_device|
  json.extract! location_device, :id, :make, :model, :serial_no, :driver, :port, :persistent
  json.url location_device_url(location_device, format: :json)
end
