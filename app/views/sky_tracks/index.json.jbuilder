json.array!(@sky_tracks) do |sky_track|
  json.extract! sky_track, :id_source, :platform, :points
  json.url sky_track_url(sky_track, format: :json)
end
