json.array!(@ground_tracks) do |ground_track|
  json.extract! ground_track, :id, :source_id, :no_edit
  json.url ground_track_url(ground_track, format: :json)
end
