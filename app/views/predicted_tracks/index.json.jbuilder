json.array!(@predicted_tracks) do |predicted_track|
  json.extract! predicted_track, :source, :file_path
  json.url predicted_track_url(predicted_track, format: :json)
end
