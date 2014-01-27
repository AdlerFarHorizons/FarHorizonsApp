json.array!(@sky_tracks) do |sky_track|
  json.extract! sky_track, :id, :source_id, :no_edit
  json.url sky_track_url(sky_track, format: :json)
end
