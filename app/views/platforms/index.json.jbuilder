json.array!(@platforms) do |platform|
  json.extract! platform, :description, :identifier, :beacons, :sky_tracks
  json.url platform_url(platform, format: :json)
end
