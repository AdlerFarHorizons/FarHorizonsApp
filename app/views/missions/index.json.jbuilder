json.array!(@missions) do |mission|
  json.extract! mission, :id, :description, :identifier, :start, :target_launch, :actual_launch, :target_end, :actual_end
  json.url mission_url(mission, format: :json)
end
