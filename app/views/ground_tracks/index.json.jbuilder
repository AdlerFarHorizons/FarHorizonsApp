json.array!(@ground_tracks) do |ground_track|
  json.extract! ground_track, :source_id, :chase_vehicle, :points
  json.url ground_track_url(ground_track, format: :json)
end
