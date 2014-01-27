json.array!(@platforms) do |platform|
  json.extract! platform, :id, :description, :identifier, :beacon_ids, :platform_server_id
  json.url platform_url(platform, format: :json)
end
